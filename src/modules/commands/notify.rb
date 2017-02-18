module Bot
  module Commands
    # Command Name
    module Notify
      extend Discordrb::Commands::CommandContainer
      command(
        [:notify, :dm, :pm],
        description: 'Toggles DM notifications',
        usage: 'notify'
      ) do |event|
        check = Database::Player.resolve_id(event.user.id).toggle_notifications
        if check
          event.channel.send_temporary_message 'User notifications turned on', 10
        else
          event.channel.send_temporary_message 'User notifications turned off', 10
        end
      end
    end
  end
end
