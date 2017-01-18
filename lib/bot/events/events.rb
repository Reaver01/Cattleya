module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			new_time = event.timestamp
			if $players.key?(event.user.id.to_s)
				if $players[event.user.id.to_s].key?('time')
					old_time = $players[event.user.id.to_s]['time']
				else
					old_time = "2017-01-01 00:00:00 +0000"
				end
				if TimeDifference.between(old_time, new_time).in_seconds > 30
					$players[event.user.id.to_s]['xp'] += rand(15..25)
					$players[event.user.id.to_s]['time'] = new_time
				end
			else
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>new_time, 'inv'=>{'0'=>1}}
			end
			next_level = 0.83333333333 * ($players[event.user.id.to_s]['level'] - 1) * (2 * $players[event.user.id.to_s]['level'] ^ 2 + 23 * $players[event.user.id.to_s]['level'] + 66)
			if $players[event.user.id.to_s]['xp'] > next_level.round
				new_zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
				$players[event.user.id.to_s]['level'] += 1
				if $players[event.user.id.to_s].key?("messages")
					if $players[event.user.id.to_s]['messages']
						BOT.user(event.user.id.to_s).pm("Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{new_zenny} Zenny and a few items you can trade or use!")
					end
				end
				$players[event.user.id.to_s]['zenny'] += new_zenny
				items_count = rand(3..5)
				new_items = []
				items_count.times do
					item = rand(0..(ITEMS.length-1))
					new_items.push(item)
					item = item.to_s
					if $players[event.user.id.to_s]['inv'].key?(item)
						$players[event.user.id.to_s]['inv'][item] += 1
					else
						$players[event.user.id.to_s]['inv'][item] = 1
					end
				end
				if $players[event.user.id.to_s].key?("messages")
					if $players[event.user.id.to_s]['messages']
						BOT.user(event.user.id.to_s).pm.send_embed '', new_items(new_items, event.user.name.to_s)
					end
				end
			end
			if $current_unstable.has_key?(event.channel.id.to_s)
				if $current_unstable[event.channel.id.to_s].has_key?('traptime')		
					if TimeDifference.between($current_unstable[event.channel.id.to_s]['traptime'], new_time).in_minutes > 2
						$current_unstable[event.channel.id.to_s]['intrap'] = false
						$current_unstable[event.channel.id.to_s] = $current_unstable[event.channel.id.to_s].without('traptime')
						event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has escaped the trap!"
					end
				end
			end
		end
	end
	message(containing: "e") do |event|
		if event.message.channel.pm?
			#does nothing
		else
			if $current_unstable.has_key?(event.channel.id.to_s)
				if $current_unstable[event.channel.id.to_s].has_key?('intrap')
					if $current_unstable[event.channel.id.to_s]['intrap']
						trap_modifier = 1.75
					else
						trap_modifier = 1
					end
				else
					trap_modifier = 1
				end
				unless $players.has_key?(event.user.id.to_s)
					hr_modifier = 0
				else
					hr_modifier = $players[event.user.id.to_s]['hr']
				end
				damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
				damage_dealt = damage_dealt.round
				$current_unstable[event.channel.id.to_s]['hp'] -= damage_dealt
				if $current_unstable[event.channel.id.to_s].has_key?('$players')
					if $current_unstable[event.channel.id.to_s]['$players'].has_key?(event.user.id.to_s)
						$current_unstable[event.channel.id.to_s]['$players'][event.user.id.to_s] += damage_dealt
						$current_unstable[event.channel.id.to_s]['$players2'][event.user.id.to_s] = event.user.name
					else
						$current_unstable[event.channel.id.to_s]['$players'][event.user.id.to_s] = damage_dealt
						$current_unstable[event.channel.id.to_s]['$players2'][event.user.id.to_s] = event.user.name
					end
				else
					$current_unstable[event.channel.id.to_s]['$players'] = {"#{event.user.id}"=>damage_dealt}
					$current_unstable[event.channel.id.to_s]['$players2'] = {"#{event.user.id}"=>event.user.name}
				end
				if $current_unstable[event.channel.id.to_s]['hp'] < 0
					event.channel.send_embed 'The monster has been killed! Here are the results:', HuntEnd($current_unstable[event.channel.id.to_s])
					$current_unstable = $current_unstable.without(event.channel.id.to_s)
				end
			end
		end
	end
end
