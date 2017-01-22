module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			unless event.message.content.include?(PREFIX)
				if $players.has_key?(event.user.id.to_s)
					if $players[event.user.id.to_s].has_key?('time')
						old_time = $players[event.user.id.to_s]['time']
					else
						#time in the distant past so it doesn't error
						old_time = '2017-01-01 00:00:00 +0000'
					end
					#30 second timeout for gaining xp
					if TimeDifference.between(old_time, event.timestamp).in_seconds > 30
						$players[event.user.id.to_s]['xp'] += rand(15..25)
						$players[event.user.id.to_s]['time'] = event.timestamp				
						#leveling up formula
						next_level = 0.83333333333 * ($players[event.user.id.to_s]['level'] - 1) * (2 * $players[event.user.id.to_s]['level'] ^ 2 + 23 * $players[event.user.id.to_s]['level'] + 66)
						#checks players xp against the formula
						if $players[event.user.id.to_s]['xp'] > next_level.round
							#gives random amount of zenny based on level
							new_zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
							#adds a level
							$players[event.user.id.to_s]['level'] += 1
							#adds the new zenny to the players
							$players[event.user.id.to_s]['zenny'] += new_zenny
							#generates new items and stores them in an array
							items_count = rand(3..5)
							new_items = []
							items_count.times do
								item = rand(0..(ITEMS.length-1))
								new_items.push(item)
								item = item.to_s
								#adds the new items to the players inventory
								if $players[event.user.id.to_s]['inv'].key?(item)
									$players[event.user.id.to_s]['inv'][item] += 1
								else
									$players[event.user.id.to_s]['inv'][item] = 1
								end
							end
							new_hp = 500 + ($players[event.user.id.to_s]['level'] * 10)
							$players[event.user.id.to_s]['max_hp'] = new_hp
							$players[event.user.id.to_s]['current_hp'] = new_hp
							#checks if player has messages set to true and messages them their new items if true
							if $players[event.user.id.to_s].key?('messages')
								if $players[event.user.id.to_s]['messages']
									begin
										BOT.user(event.user.id.to_s).pm.send_embed "Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{new_zenny} Zenny and a few items you can trade or use!", new_items(new_items, event.user.name.to_s)
									rescue
										mute_log(event.user.id.to_s)
									end
								end
							end
						end
					end
				else
					#initial array for new player
					$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'max_hp'=>500, 'current_hp'=>500, 'time'=>event.timestamp, 'inv'=>{'0'=>1}}
				end
			end
		end
	end
end
