require 'time_difference'

module Bot
  module Database
    # Mixin to allow objects to be trapped
    module Trap
      # @return [Object] minutes
      def trapped_for
        TimeDifference.between(trapped_since, Time.now).in_minutes
      end

      # @return [Boolean] has the object been trapped for more than 2 minutes?
      def trap_expired?
        trapped_for > 2
      end

      # @return [Boolean] has the object been trapped for less than 2 minutes?
      def trapped?
        trapped_for < 2
      end

      # @return [Object] time
      def become_trapped
        trapped_since = Time.now
      end
    end
  end
end
