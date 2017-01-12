module Commands
	module Notify
		extend Discordrb::Commands::CommandContainer
		command(
				:notify,
				description: "toggles pm notifications of level and other things",
				useage: "notify"
		) do |event|
			if $players[event.user.id.to_s].key?("messages")
				if $players[event.user.id.to_s]['messages']
					pmstatus = false
					$bot.user(event.user.id.to_s).pm("PM notifications have been toggled off. How sad.")
				else
					pmstatus = true
					$bot.user(event.user.id.to_s).pm("PM notifications have been toggled on! I love sending notifications!")
				end
			else
				pmstatus = true
				$bot.user(event.user.id.to_s).pm("PM notifications have been toggled on! I love sending notifications!")
			end
			$players[event.user.id.to_s]['messages'] = pmstatus
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: notify"
			nil
		end
	end
end
