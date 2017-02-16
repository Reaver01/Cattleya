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
        Database::Player.resolve_id(event.user.id).toggle_notifications
        Database::Player.resolve_id(event.user.id).notifications
      end
    end
  end
end
