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
			puts "#{event.timestamp}: #{event.user.name}: CMD: kill"
			BOT.send_message(event.message.channel, "Saving data and shutting down... I'll be back.")
			File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
			File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
			BOT.stop
			exit
			nil
		end
	end
end
