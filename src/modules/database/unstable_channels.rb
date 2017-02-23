module Bot
  module Database
    # Unstable Channel table
    class UnstableChannel < Sequel::Model
      def self.check(channel_id)
        find(channel_id: channel_id) || create(channel_id: channel_id)
      end

      # Toggles the unstable attribute for a channel
      # @return [Trueclass] True if unstable was toggled on
      def toggle
        status = unstable
        if status
          update(unstable: false)
          false
        else
          update(unstable: true)
          true
        end
      end
    end
  end
end
