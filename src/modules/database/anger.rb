require 'time_difference'

module Bot
  module Database
    # Mixin that allows objects to become angry.
    module Anger
      # @return [Object] minutes
      def angry_for
        TimeDifference.between(angry_since, Time.now).in_minutes
      end

      # @return [Boolean] has the object been angry for less than 3 minutes?
      def angry?
        angry_for < 3
      end

      # @param amount [Integer] adds anger
      # @return [Integer] new anger level
      # @return [Object] time
      def add_anger(amount = 1)
        update(anger_level: anger_level + amount) unless angry?
        if anger_level > 100
          become_angry
        else
          false
        end
      end

      # Drops the anger level back down to 0 so the object can start being angry
      # again when it's no longer angry.
      # Sets angry_since to the current time.
      # @return [Object] time
      def become_angry
        update(anger_level: 0, angry_since: Time.now)
        true
      end
    end
  end
end
