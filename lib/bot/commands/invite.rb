module Commands
	module Invite
		extend Discordrb::Commands::CommandContainer
		command(
				:invite,
				description: "Shows the invite link for the bot.",
				useage: "invite"
		) do |event|
			event.respond  "Invite Link: <#{BOT.invite_url}>"
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: invite"
			nil
		end
	end
end
