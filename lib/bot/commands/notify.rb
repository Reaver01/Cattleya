module Commands
	module Notify
		extend Discordrb::Commands::CommandContainer
		command(
				:notify,
				description: "Toggles pm notifications of level.",
				useage: "notify"
		) do |event|
			if PLAYERS[event.user.id.to_s].key?("messages")
				if PLAYERS[event.user.id.to_s]['messages']
					pm_status = false
					BOT.user(event.user.id.to_s).pm("PM notifications have been toggled off. How sad.")
				else
					pm_status = true
					BOT.user(event.user.id.to_s).pm("PM notifications have been toggled on! I love sending notifications!")
				end
			else
				pm_status = true
				BOT.user(event.user.id.to_s).pm("PM notifications have been toggled on! I love sending notifications!")
			end
			PLAYERS[event.user.id.to_s]['messages'] = pm_status
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: notify"
			nil
		end
	end
end
