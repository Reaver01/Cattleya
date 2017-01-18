module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			newtime = event.timestamp
			if $players.key?(event.user.id.to_s)
				if $players[event.user.id.to_s].key?('time')
					oldtime = $players[event.user.id.to_s]['time']
				else
					oldtime = "2017-01-01 00:00:00 +0000"
				end
				if TimeDifference.between(oldtime, newtime).in_seconds > 30
					$players[event.user.id.to_s]['xp'] += rand(15..25)
					$players[event.user.id.to_s]['time'] = newtime
				end
			else
				$players[event.user.id.to_s] = {'xp'=>0, 'level'=>0, 'hr'=>0, 'zenny'=>100, 'time'=>newtime, 'inv'=>{'0'=>1}}
			end
			nextlevel = 0.83333333333 * ($players[event.user.id.to_s]['level'] - 1) * (2 * $players[event.user.id.to_s]['level'] ^ 2 + 23 * $players[event.user.id.to_s]['level'] + 66)
			if $players[event.user.id.to_s]['xp'] > nextlevel.round
				zenny = (rand(0..9) * 10) + (rand(0..9) * 100) + (($players[event.user.id.to_s]['level'] / 4).floor * 1000)
				$players[event.user.id.to_s]['level'] += 1
				if $players[event.user.id.to_s].key?("messages")
					if $players[event.user.id.to_s]['messages']
						$bot.user(event.user.id.to_s).pm("Congratulations! You have leveled up to Level #{$players[event.user.id.to_s]['level']}\nYou have earned yourself #{zenny} Zenny and a few items you can trade or use!")
					end
				end
				$players[event.user.id.to_s]['zenny'] += zenny
				numitems = rand(3..5)
				newitems = []
				numitems.times do
					item = rand(0..($items.length-1))
					newitems.push(item)
					item = item.to_s
					if $players[event.user.id.to_s]['inv'].key?(item)
						$players[event.user.id.to_s]['inv'][item] += 1
					else
						$players[event.user.id.to_s]['inv'][item] = 1
					end
				end
				if $players[event.user.id.to_s].key?("messages")
					if $players[event.user.id.to_s]['messages']
						$bot.user(event.user.id.to_s).pm.send_embed '', newItems(newitems, event.user.name.to_s)
					end
				end
			end
			if $curunst.has_key?(event.channel.id.to_s)
				if $curunst[event.channel.id.to_s].has_key?('intrap')
					if $curunst[event.channel.id.to_s].has_key?('traptime')		
						if TimeDifference.between($curunst[event.channel.id.to_s]['traptime'], newtime).in_minutes > 2
							$curunst[event.channel.id.to_s]['intrap'] = false
						end
					end
				end
			end
		end
	end
	message(containing: "e") do |event|
		if event.message.channel.pm?
			#does nothing
		else
			if $curunst.has_key?(event.channel.id.to_s)
				if $curunst[event.channel.id.to_s].has_key?('intrap')
					if $curunst[event.channel.id.to_s]['intrap']
						trap = 1.75
					else
						trap = 1
					end
				else
					trap = 1
				end
				unless $players.has_key?(event.user.id.to_s)
					mod = 0
				else
					mod = $players[event.user.id.to_s]['hr']
				end
				dam = rand(0..(10 + mod)) * trap
				dam = dam.round
				$curunst[event.channel.id.to_s]['hp'] -= dam
				if $curunst[event.channel.id.to_s].has_key?('players')
					if $curunst[event.channel.id.to_s]['players'].has_key?(event.user.id.to_s)
						$curunst[event.channel.id.to_s]['players'][event.user.id.to_s] += dam
						$curunst[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
					else
						$curunst[event.channel.id.to_s]['players'][event.user.id.to_s] = dam
						$curunst[event.channel.id.to_s]['players2'][event.user.id.to_s] = event.user.name
					end
				else
					$curunst[event.channel.id.to_s]['players'] = {"#{event.user.id}"=>dam}
					$curunst[event.channel.id.to_s]['players2'] = {"#{event.user.id}"=>event.user.name}
				end
				if $curunst[event.channel.id.to_s]['hp'] < 0
					event.channel.send_embed 'The monster has been killed! Here are the results:', huntEnd($curunst[event.channel.id.to_s])
					$curunst = $curunst.without(event.channel.id.to_s)
				end
			end
		end
	end
end
