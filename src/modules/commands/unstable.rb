module Bot
  module Commands
    # Command Name
    module Unstable
      extend Discordrb::Commands::CommandContainer
      command(
        [:unstable, :unst],
        description: 'Toggles monster appearance',
        usage: 'unstable',
        required_permissions: [:manage_channels],
        permission_message: 'Only a channel manager can use %name%'
      ) do |event|
        check = Database::UnstableChannel.check(event.channel.id).toggle
        if check
          event.channel.send_temporary_message 'Unstable turned on', 60
        else
          event.channel.send_temporary_message 'Unstable turned off', 60
        end

        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
