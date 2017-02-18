require 'time_difference'

module Bot
  module Database
    # Player table
    class Player < Sequel::Model
      one_to_many :items
      one_to_many :monster_attackers

      # ---- INFO AND CREATION ----

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

      # ---- HEALTH AND DAMAGE ----

      # @params amount [Integer] The amount of damage dealt to the player
      # @return [Integer] The new health value of the player
      def add_damage(amount)
        new_hp = hp - amount
        update(hp: new_hp)
        new_hp
      end

      # @return [Boolean] True if the player has been dead less than 5 mins
      def carting?
        dead_for < 5
      end

      # @return [Boolean] True if the players health is less than 1
      def dead?
        hp < 1
      end

      # @return [Integer] The amount of time in minutes the player has been dead
      def dead_for
        TimeDifference.between(death_time, Time.now).in_minutes
      end

      # Sets the players death time to the current time
      # @return [Time] the time of death for the player
      def died
        update(death_time: Time.now)
        death_time
      end

      # ---- ITEMS AND INVENTORY ----

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

      def item_amount(item)
        existing_item = item(item)
        if existing_item
          existing_item.quantity
        else
          0
        end
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
          if new_item
            add_item(item_definition_id: new_item.id, quantity: amount)
          end
        end
      end

      # @params new_item [Object] Database::ItemDefinition[n]
      def remove_item(new_item)
        existing_item = item(new_item)
        if existing_item
          quantity = existing_item.quantity - 1
          existing_item.update quantity: quantity unless quantity.negative?
        end
      end

      # @params amount [Integer] The amount of zenny to remove from the player
      def remove_zenny(amount)
        update(zenny: zenny - amount)
      end

      # ---- LEVELS AND HEALTH ----

      # @param amount [Integer] xp amount
      # @return [Boolean] true if player leveled up
      def add_xp(amount)
        update(xp: xp + amount) if can_gain_xp?
        if enough_xp?
          new_zenny = level_up_zenny
          new_items = []
          rand(3..5).times do
            new_items.push(rand(1..(Database::ItemDefinition.count)))
          end
          level_up(new_zenny, new_items)
          { leveled_up: true, zenny: new_zenny, embed: new_items_embed(new_items) }
        else
          { leveled_up: false }
        end
      end

      # @return [Boolean] True if the amount of time exceeds 30 seconds
      def can_gain_xp?
        no_xp_for > 30
      end

      # @return [Boolean] Checks if the player can level up
      def enough_xp?
        xp > next_level
      end

      # @params new_zenny [Integer] The amount of zenny earned on level up
      # @params new_items [Array] The items the player recieved on level up
      def level_up(new_zenny, new_items)
        update(level: level + 1, zenny: zenny + new_zenny)
        new_items.each { |x| give_item Database::ItemDefinition[x] }
        raise_max_hp
      end

      # @return [Integer] The amount of zenny a player would earn on level up
      def level_up_zenny
        (rand(0..9) * 10) + (rand(0..9) * 100) + ((level / 4).floor * 1000)
      end

      # @return [Float] XP required to gain the next level
      def next_level
        0.8333333333 * (level - 1) * (2 * level ^ 2 + 23 * level + 66)
      end

      # @return [Integer] The amount of seconds the player has not gained any xp
      def no_xp_for
        TimeDifference.between(last_xp_gain, Time.now).in_seconds
      end

      # Raises max HP of the player
      def raise_max_hp
        update(max_hp: max_hp + 10)
        set_hp_to_max
      end

      # Sets player health back to max
      def set_hp_to_max
        update(hp: max_hp)
      end

      # ---- EMBEDS ----

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

      # @return [object] embed
      def new_items_embed(new_items)
        embed = Discordrb::Webhooks::Embed.new
        embed.title = 'Here are the new items you recieved!'
        embed.color = rand(0xffffff)
        embed.description = ''
        new_items.each do |item|
          embed.description += "**#{Database::ItemDefinition[item].name}**\n"
        end
        embed
      end
    end
  end
end
