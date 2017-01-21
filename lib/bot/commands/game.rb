module Commands
	module Game
		extend Discordrb::Commands::CommandContainer
		command(
				:game,
				description: 'Sets game status of the bot',
				usage: 'game <text>',
				help_available: false,
				min_args: 1,
				permission_level: 2,
		) do |event, *text|
			$settings['game'] = text.join(' ')
			BOT.game = $settings['game']
			File.open('botfiles/settings.json', 'w') { |f| f.write $settings.to_json }
			command_log('game', event.user.name)
			nil
		end
	end
end
