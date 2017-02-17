require 'time_difference'

module Bot
  module Database
    # Defines a human player of the game.
    class Player < Sequel::Model
      one_to_many :items
      one_to_many :monster_attackers

      include Levels

      include Hitpoints

      def self.resolve_id(id)
        find(discord_id: id) || create(discord_id: id)
      end

      def toggle_notifications
        status = notifications
        if status
          update(notifications: false)
        else
          update(notifications: true)
        end
      end

      def dead_for
        TimeDifference.between(death_time, Time.now).in_minutes
      end

      def carting?
        dead_for < 5
      end

      # item = Database::ItemDefinition[n]
      def item(item)
        items.find { |i| i.item_definition_id == item.id }
      end

      def item?(item)
        !!item(item)
      end

      def give_item(new_item, quantity = 1)
        existing_item = item(new_item)
        if existing_item
          quantity ||= existing_item.quantity + 1
          existing_item.update quantity: quantity
        else
          add_item item_definition_id: new_item.id, quantity: quantity
        end
      end

      def remove_item(new_item)
        existing_item = item(new_item)
        if existing_item
          quantity = existing_item.quantity - 1
          existing_item.update quantity: quantity unless quantity < 0
        end
      end

      def info_embed
        embed = Discordrb::Webhooks::Embed.new
        username = BOT.parse_mention("<@#{discord_id}>").name
        avatar = BOT.parse_mention("<@#{discord_id}>").avatar_url
        embed.title = "This is info all about #{username}!"
        embed.thumbnail = { url: avatar }
        embed.color = rand(0xffffff)
        embed.description = "**Level:** #{level}\n**HR:** #{hr}\n**XP:** " \
          "#{xp}\n**Current HP:** #{hp}\n**Zenny:** #{zenny}\n**Inventory:** " \
          "#{items.map(&:quantity).reduce(:+) || 0} items"
        embed.timestamp = Time.now
        embed
      end
    end
  end
end
