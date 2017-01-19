module Commands
	module Notify
		extend Discordrb::Commands::CommandContainer
		command(
				:notify,
				description: "Toggles pm notifications of level.",
				useage: "notify"
		) do |event|
			if $players[event.user.id.to_s].key?("messages")
				if $players[event.user.id.to_s]['messages']
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
			$players[event.user.id.to_s]['messages'] = pm_status
			command_log("notify", event.user.name)
			nil
		end
	end
end
