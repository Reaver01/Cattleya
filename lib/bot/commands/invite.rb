module Commands
	module Invite
		extend Discordrb::Commands::CommandContainer
		command(
				:invite,
				description: "Shows the invite link for the bot.",
				useage: "invite"
		) do |event|
			event.respond  "Invite Link: <#{BOT.invite_url}>"
			command_log("invite", event.user.name)
			nil
		end
	end
end
