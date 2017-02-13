module Commands
  # Command Module
  module Invite
    extend Discordrb::Commands::CommandContainer
    command(
      :invite,
      description: 'Shows the invite link for the bot',
      usage: 'invite'
    ) do |event|
      begin
        m = "Invite Link: <#{BOT.invite_url(
          permission_bits: 93_248
        )}>"
      rescue
        mute_log(event.channel.id.to_s)
      end
      command_log('invite', event.user.name)
      m
    end
  end
end
