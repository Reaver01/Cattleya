require 'time_difference'

module Bot
  module Database
    # Player table
    class Player < Sequel::Model
      one_to_many :items
      one_to_many :monster_attackers

      include Levels

      # @params id [Integer] The discord id of the player
      # @return [Object] The new player object if none existed, or the current one if it did
      def self.resolve_id(id)
        find(discord_id: id) || create(discord_id: id)
      end

      # @return [Integer] The discord id of the player
      def user
        BOT.user discord_id
      end

      # toggles the notifications setting true or false
      def toggle_notifications
        status = notifications
        if status
          update(notifications: false)
          false
        else
          update(notifications: true)
          true
        end
      end

      # @return [Integer] The amount of time in minutes the player has been dead
      def dead_for
        TimeDifference.between(death_time, Time.now).in_minutes
      end

      # @params amount [Integer] The amount of damage dealt to the player
      # @return [Integer] The new health value of the player
      def add_damage(amount)
        new_hp = hp - amount
        update(hp: new_hp)
        new_hp
      end

      # @return [Boolean] True if the players health is less than 1
      def dead?
        hp < 1
      end

      # Sets the players death time to the current time
      # @return [Time] the time of death for the player
      def died
        update(death_time: Time.now)
        death_time
      end

      # @return [Boolean] True if the player has been dead less than 5 mins
      def carting?
        dead_for < 5
      end

      # @params item [Object] Database::ItemDefinition[n]
      # @return [Object] The item in the players inventory
      def item(item)
        items.find { |i| i.item_definition_id == item.id }
      end

      # @params item [Object] Database::ItemDefinition[n]
      # @return [Boolean] True if the object exists in the players inventory
      def item?(item)
        !!item(item)
      end

      # @params new_item [Object] Database::ItemDefinition[n]
      # @params quantity [Integer] The amount to set the players item to. If not set it will add one
      # of the specified item to the players inventory
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

      # @params new_item [Object] Database::ItemDefinition[n]
      # @params quantity [Integer] The number of items to add to the players inventory
      def buy_item(new_item, quantity = 1)
        existing_item = item(new_item)
        if existing_item
          existing_item.update quantity: existing_item.quantity + quantity
        else
          add_item item_definition_id: new_item.id, quantity: quantity
        end
      end

      # @params amount [Integer] The amount of zenny to remove from the player
      def remove_zenny(amount)
        update(zenny: zenny - amount)
      end

      # @params new_item [Object] Database::ItemDefinition[n]
      def remove_item(new_item)
        existing_item = item(new_item)
        if existing_item
          quantity = existing_item.quantity - 1
          existing_item.update quantity: quantity unless quantity.negative?
        end
      end

      # @return [object] embed
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

      # @return [object] embed
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
