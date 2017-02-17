require 'time_difference'

module Bot
  module Database
    # Player table
    class Player < Sequel::Model
      one_to_many :items
      one_to_many :monster_attackers

      include Levels

      def self.resolve_id(id)
        find(discord_id: id) || create(discord_id: id)
      end

      def user
        BOT.user discord_id
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

      def add_damage(amount)
        new_hp = hp - amount
        update(hp: new_hp)
        new_hp
      end

      def dead?
        hp < 1
      end

      def died
        update(death_time: Time.now)
        death_time
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

      def give_item(new_item, quantity = nil)
        existing_item = item(new_item)
        if existing_item
          amount = if quantity.nil?
                     existing_item.quantity + 1
                   else
                     quantity
                   end
          existing_item.update quantity: amount
        else
          amount = if quantity.nil?
                     1
                   else
                     quantity
                   end
          add_item item_definition_id: new_item.id, quantity: amount
        end
      end

      def remove_item(new_item)
        existing_item = item(new_item)
        if existing_item
          quantity = existing_item.quantity - 1
          existing_item.update quantity: quantity unless quantity.negative?
        end
      end

      def info_embed
        embed = Discordrb::Webhooks::Embed.new
        embed.title = "This is info all about #{user.name}!"
        embed.thumbnail = { url: user.avatar_url }
        embed.color = rand(0xffffff)
        embed.description = "**Level:** #{level}\n**HR:** #{hr}\n**XP:** " \
          "#{xp}\n**Current HP:** #{hp}\n**Zenny:** #{zenny}\n**Inventory:** " \
          "#{items.map(&:quantity).reduce(:+) || 0} items"
        embed.timestamp = Time.now
        embed
      end

      def inventory_embed
        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Here is your inventory'
        embed.thumbnail = { url: user.avatar_url }
        embed.color = rand(0xffffff)
        embed.description = "**Zenny:** #{zenny}\n\n"
        items.each do |item|
          embed.description += "**#{item.item_definition.name}:** #{item.quantity}\n"
        end
        embed.timestamp = Time.now
        embed
      end
    end
  end
end
