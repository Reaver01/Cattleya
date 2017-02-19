module Bot
  module Commands
    # Command Name
    module Invite
      extend Discordrb::Commands::CommandContainer
      command(
        :invite,
        description: 'Shows the invite link for the bot',
        usage: 'invite'
      ) do |_event|
        "Invite Link: <#{BOT.invite_url(permission_bits: 93_248)}>"
      end
    end
  end
end
