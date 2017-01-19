module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			if $players.has_key?(event.user.id.to_s)
				if $players[event.user.id.to_s].has_key?('time')
					old_time = $players[event.user.id.to_s]['time']
				else
					#time in the distant past so it doesn't error
					old_time = "2017-01-01 00:00:00 +0000"
				end
				#30 second timeout for gaining xp
				if TimeDifference.between(old_time, event.timestamp).in_seconds > 30
					$players[event.user.id.to_s]['xp'] += rand(15..25)
					$players[event.user.id.to_s]['time'] = event.timestamp
				end
			else
				#initial array for new player
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>event.timestamp, 'inv'=>{'0'=>1}}
			end
			#leveling up formula
			next_level = 0.83333333333 * ($players[event.user.id.to_s]['level'] - 1) * (2 * $players[event.user.id.to_s]['level'] ^ 2 + 23 * $players[event.user.id.to_s]['level'] + 66)
			#checks players xp against the formula
			if $players[event.user.id.to_s]['xp'] > next_level.round
				#gives random amount of zenny based on level
				new_zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
				#adds a level and messages the player if they have the messages set as true
				$players[event.user.id.to_s]['level'] += 1
				if $players[event.user.id.to_s].has_key?("messages")
					if $players[event.user.id.to_s]['messages']
						BOT.user(event.user.id.to_s).pm("Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{new_zenny} Zenny and a few items you can trade or use!")
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
				if $players[event.user.id.to_s].key?("messages")
					if $players[event.user.id.to_s]['messages']
						BOT.user(event.user.id.to_s).pm.send_embed '', new_items(new_items, event.user.name.to_s)
					end
				end
			end
			#checks to see if a monster is in a trap longer than 2 mins and releases it if it is
			if $current_unstable.has_key?(event.channel.id.to_s)
				if $current_unstable[event.channel.id.to_s].has_key?('traptime')		
					if TimeDifference.between($current_unstable[event.channel.id.to_s]['traptime'], event.timestamp).in_minutes > 2
						$current_unstable[event.channel.id.to_s]['intrap'] = false
						$current_unstable[event.channel.id.to_s] = $current_unstable[event.channel.id.to_s].without('traptime')
						event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has escaped the trap!"
					end
				end
			end
			#checks to see if a monster is angry longer than 3 mins and stops anger if it is
			if $current_unstable.has_key?(event.channel.id.to_s)
				if $current_unstable[event.channel.id.to_s].has_key?('angertime')		
					if TimeDifference.between($current_unstable[event.channel.id.to_s]['angertime'], event.timestamp).in_minutes > 3
						$current_unstable[event.channel.id.to_s]['angry'] = false
						$current_unstable[event.channel.id.to_s] = $current_unstable[event.channel.id.to_s].without('angertime')
						event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} is no longer angry!"
					end
				end
			end
		end
	end
	#dealing damage to monsters trigger
	message(containing: "e") do |event|
		if event.message.channel.pm?
			#does nothing
		else
			if $current_unstable.has_key?(event.channel.id.to_s)
				#checks if the monster is in a trap and modifies damage if it is
				if $current_unstable[event.channel.id.to_s].has_key?('intrap')
					if $current_unstable[event.channel.id.to_s]['intrap']
						trap_modifier = 1.75
					else
						trap_modifier = 1
					end
				else
					trap_modifier = 1
				end
				#checks players hr and modifies damage
				unless $players.has_key?(event.user.id.to_s)
					hr_modifier = 0
				else
					hr_modifier = $players[event.user.id.to_s]['hr']
				end
				#final damage dealt calculated and rounded to integer
				damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
				damage_dealt = damage_dealt.round
				$current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
				#stores the player that did damage in the unstable array with their damage dealt
				if $current_unstable[event.channel.id.to_s].has_key?('players')
					if $current_unstable[event.channel.id.to_s]['players'].has_key?(event.user.id.to_s)
						$current_unstable[event.channel.id.to_s]['players'][event.user.id.to_s] += damage_dealt
						$current_unstable[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
					else
						$current_unstable[event.channel.id.to_s]['players'][event.user.id.to_s] = damage_dealt
						$current_unstable[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
					end
				else
					$current_unstable[event.channel.id.to_s]['players'] = {"#{event.user.id}"=>damage_dealt}
					$current_unstable[event.channel.id.to_s]['players2'] = {"#{event.user.id}"=>event.user.name}
				end
				#checks if the monster is dead and displays end results if it is
				if $current_unstable[event.channel.id.to_s]['hp'] < 0
					event.channel.send_embed 'The monster has been killed! Here are the results:', hunt_end($current_unstable[event.channel.id.to_s])
					$current_unstable = $current_unstable.without(event.channel.id.to_s)
				end
			end
		end
	end
	#making monsters angry trigger
	message(containing: "r") do |event|
		if event.message.channel.pm?
			#does nothing
		else
			if $current_unstable.has_key?(event.channel.id.to_s)
				unless $current_unstable[event.channel.id.to_s].has_key?('angry')
					$current_unstable[event.channel.id.to_s]['angry'] = false
				end
				unless $current_unstable[event.channel.id.to_s]['angry']
					if $current_unstable[event.channel.id.to_s].has_key?('anger')
						$current_unstable[event.channel.id.to_s]['anger'] += 1
					else
						$current_unstable[event.channel.id.to_s]['anger'] = 1
					end
					if $current_unstable[event.channel.id.to_s]['anger'] > 50
						$current_unstable[event.channel.id.to_s]['angry'] = true
						$current_unstable[event.channel.id.to_s]['angertime'] = Time.now
						$current_unstable[event.channel.id.to_s]['anger'] = 0
						event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has become angry!"
					end
				end
			end
		end
	end
end
