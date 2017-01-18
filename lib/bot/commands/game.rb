module Commands
	module Game
		extend Discordrb::Commands::CommandContainer
		command(
				:game,
				description: "Sets game status of the bot.",
				usage: "game <text>",
				help_available: false,
				min_args: 1,
				permission_level: 2,
		) do |event, *text|
			SETTINGS['game'] = text.join(' ')
			BOT.game = SETTINGS['game']
			File.open('botfiles/settings.json', 'w') { |f| f.write SETTINGS.to_json }
			puts "#{event.timestamp}: #{event.user.name}: CMD: game <#{gametext}>"
			nil
		end
	end
end
