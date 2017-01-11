module Commands
	module Kill
		extend Discordrb::Commands::CommandContainer
		command(
				:kill,
				description: "Kills the bot",
				useage: "kill",
				help_available: false,
				permission_level: 800,
		) do |event|
			puts "[#{event.timestamp.strftime("%d %a %y | %H:%M:%S")}] #{event.user.name}: CMD: kill"
			$bot.send_message(event.message.channel, "Shutting down... I'll be back.")
			$bot.stop
			exit
			nil
		end
	end
end
