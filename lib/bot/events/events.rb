module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			puts "pm"
		else

			if $players.key?(event.user.id.to_s)
				$players[event.user.id.to_s]['xp'] += rand(15..25)
			else
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'inv'=>{'0'=>1}}
			end

			if $players[event.user.id.to_s]['xp'] > $levels[$players[event.user.id.to_s]['level']+1]
				zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
				$players[event.user.id.to_s]['level'] += 1
				$bot.user(event.user.id.to_s).pm("Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{zenny} Zenny and a few items you can trade or use!")
				$players[event.user.id.to_s]['zenny'] += zenny
				numitems = rand(3..5)
				numitems.times do
					item = rand(0..($items.length-1))
					item = item.to_s
					if $players[event.user.id.to_s]['inv'].key?(item)
						$players[event.user.id.to_s]['inv'][item] += 1
					else
						$players[event.user.id.to_s]['inv'][item] = 1
					end
				end
			end

		end
	end
end