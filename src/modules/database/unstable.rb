module Bot
  module Commands
    # Command Name
    module Unstable
      extend Discordrb::Commands::CommandContainer
      command(
        [:unstable, :unst],
        description: 'Toggles monster appearance',
        usage: 'unstable'
      ) do |event|
        Database::UnstableChannel.check(event.channel.id).toggle
        if Database::UnstableChannel.check(event.channel.id).unstable
          event.channel.send_temporary_message 'Unstable turned on', 10
        else
          event.channel.send_temporary_message 'Unstable turned off', 10
        end
      end
    end
  end
end
