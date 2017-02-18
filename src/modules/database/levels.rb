require 'time_difference'

module Bot
  module Database
    # Mixin that allows objects to have levels with scaling health.
    module Levels
      # @return [Float] XP required to gain the next level
      def next_level
        0.8333333333 * (level - 1) * (2 * level ^ 2 + 23 * level + 66)
      end

      # @return [Integer] The amount of zenny a player would earn on level up
      def level_up_zenny
        (rand(0..9) * 10) + (rand(0..9) * 100) + ((level / 4).floor * 1000)
      end

      # @return [Boolean] Checks if the player can level up
      def enough_xp?
        xp > next_level
      end

      # @return [Integer] The amount of seconds the player has not gained any xp
      def no_xp_for
        TimeDifference.between(last_xp_gain, Time.now).in_seconds
      end

      # @return [Boolean] True if the amount of time exceeds 30 seconds
      def can_gain_xp?
        no_xp_for > 30
      end

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

      # @params new_zenny [Integer] The amount of zenny earned on level up
      # @params new_items [Array] The items the player recieved on level up
      def level_up(new_zenny, new_items)
        update(level: level + 1, zenny: zenny + new_zenny)
        new_items.each { |x| give_item Database::ItemDefinition[x] }
        raise_max_hp
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
