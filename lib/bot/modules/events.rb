module Events
	extend Discordrb::EventContainer
	message do |event|
		#leveling up formula
		next_level = 0.83333333333 * ($players[event.user.id.to_s]['level'] - 1) * (2 * $players[event.user.id.to_s]['level'] ^ 2 + 23 * $players[event.user.id.to_s]['level'] + 66)
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
						#checks players xp against the formula
						if $players[event.user.id.to_s]['xp'] > next_level.round
							#gives random amount of zenny based on level
							new_zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
							#adds a level and messages the player if they have the messages set as true
							$players[event.user.id.to_s]['level'] += 1
							if $players[event.user.id.to_s].has_key?('messages')
								if $players[event.user.id.to_s]['messages']
									begin
										BOT.user(event.user.id.to_s).pm("Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{new_zenny} Zenny and a few items you can trade or use!")
									rescue
										mute_log(event.user.id.to_s)
									end
								end
							end
							#adds the new zenny to the players
							$players[event.user.id.to_s]['zenny'] += new_zenny
							#generates new items and stores them in an array
							items_count = rand(3..5)
							new_items = []
							items_count.times do
								item = rand(0..($items.length-1))
								new_items.push(item)
								item = item.to_s
								#adds the new items to the players inventory
								if $players[event.user.id.to_s]['inv'].key?(item)
									$players[event.user.id.to_s]['inv'][item] += 1
								else
									$players[event.user.id.to_s]['inv'][item] = 1
								end
							end
							#checks if player has messages set to true and messages them their new items if true
							if $players[event.user.id.to_s].key?('messages')
								if $players[event.user.id.to_s]['messages']
									begin
										BOT.user(event.user.id.to_s).pm.send_embed '', new_items(new_items, event.user.name.to_s)
									rescue
										mute_log(event.user.id.to_s)
									end
								end
							end
						end
					end
				else
					#initial array for new player
					$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>event.timestamp, 'inv'=>{'0'=>1}}
				end
				#checks to see if a monster is in a trap longer than 2 mins and releases it if it is
				if $current_unstable.has_key?(event.channel.id.to_s)
					if $current_unstable[event.channel.id.to_s].has_key?('traptime')		
						if TimeDifference.between($current_unstable[event.channel.id.to_s]['traptime'], event.timestamp).in_minutes > 2
							$current_unstable[event.channel.id.to_s]['intrap'] = false
							$current_unstable[event.channel.id.to_s] = $current_unstable[event.channel.id.to_s].without('traptime')
							begin
								event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has escaped the trap!"
							rescue
								mute_log(event.channel.id.to_s)
							end
						end
					end
				end
				#checks to see if a monster is angry longer than 3 mins and stops anger if it is
				if $current_unstable.has_key?(event.channel.id.to_s)
					if $current_unstable[event.channel.id.to_s].has_key?('angertime')		
						if TimeDifference.between($current_unstable[event.channel.id.to_s]['angertime'], event.timestamp).in_minutes > 3
							$current_unstable[event.channel.id.to_s]['angry'] = false
							$current_unstable[event.channel.id.to_s] = $current_unstable[event.channel.id.to_s].without('angertime')
							begin
								event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} is no longer angry!"
							rescue
								mute_log(event.channel.id.to_s)
							end
						end
					end
				end
			end
		end
	end
end
