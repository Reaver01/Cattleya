require 'time_difference'

module Bot
  module Database
    # Mixin that allows objects to have levels with scaling health.
    module Levels
      # @return [Float] xp to next level
      def next_level
        0.8333333333 * (level - 1) * (2 * level ^ 2 + 23 * level + 66)
      end

      def level_up_zenny
        (rand(0..9) * 10) + (rand(0..9) * 100) + ((level / 4).floor * 1000)
      end

      # @return [Boolean] can object level up
      def enough_xp?
        xp > next_level
      end

      def no_xp_for
        TimeDifference.between(last_xp_gain, Time.now).in_seconds
      end

      def can_gain_xp?
        no_xp_for > 30
      end

      # @param amount [Integer] xp amount
      # @return [Boolean] true if object leveled up
      def add_xp(amount)
        update(xp: xp + amount) if can_gain_xp?
        if enough_xp?
          new_zenny = level_up_zenny
          level_up(new_zenny)
          [true, new_zenny]
        else
          [false]
        end
      end

      # Levels up the object
      def level_up(new_zenny)
        update(level: level + 1, zenny: zenny + new_zenny)
        raise_max_hp
      end

      # Raises max HP of the object
      def raise_max_hp
        update(max_hp: max_hp + 10)
        set_hp_to_max
      end

      # Sets objects health back to max
      def set_hp_to_max
        update(hp: max_hp)
      end
    end
  end
end
