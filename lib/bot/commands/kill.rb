module Commands
	module Kill
		extend Discordrb::Commands::CommandContainer
		command(
				:kill,
				description: 'Kills the bot',
				useage: 'kill',
				help_available: false,
				permission_level: 800,
		) do |event|
			command_log('kill', event.user.name)
			begin
				event.respond "Saving data and shutting down... I'll be back."
			rescue
				mute_log(event.channel.id.to_s)
			end
			File.open('botfiles/players.json', 'w') { |f| f.write $players.to_json }
			File.open('botfiles/current_unstable.json', 'w') { |f| f.write $current_unstable.to_json }
			BOT.stop
			exit
			nil
		end
	end
end
