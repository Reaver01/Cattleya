def hit(event_user, event_channel)
	if $current_unstable.has_key?(event_channel.id.to_s)
		debug(3, "[HIT] There is a monster in the channel.")
		if $current_unstable[event_channel.id.to_s].has_key?('intrap')
			debug(5, "[HIT] Monster has intrap key.")
			if $current_unstable[event_channel.id.to_s]['intrap']
				debug(7, "[HIT] Monster is in a trap | Setting modifier.")
				trap_modifier = 1.75
			else
				debug(10, "[HIT] Monster is not in a trap | Setting modifier to 1.")
				trap_modifier = 1
			end
		else
			debug(14, "[HIT] Monster doesn't have intrap key | Setting modifier to 1.")
			trap_modifier = 1
		end
		unless $players.has_key?(event_user.id.to_s)
			debug(19, "[HIT] Player doesn't have HR | Setting modifier to 0.")
			hr_modifier = 0
		else
			debug(22, "[HIT] Player has HR | Setting modifier.")
			hr_modifier = $players[event_user.id.to_s]['hr']
		end
		damage_dealt = 0
		if $current_unstable[event_channel.id.to_s].has_key?('is_dead')
			debug(26, "[HIT] Monster has is_dead key.")
			if $current_unstable[event_channel.id.to_s]['is_dead'].has_key?(event_user.id.to_s)
				debug(28, "[HIT] is_dead has key for player.")
				unless $current_unstable[event_channel.id.to_s]['is_dead'][event_user.id.to_s]
					debug(30, "[HIT] Player is not dead | calculating and dealing damage.")
					damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
					damage_dealt = damage_dealt.round
					$current_unstable[event_channel.id.to_s]['hp'] -= damage_dealt
				end
			else
				debug(36, "[HIT] No is_dead key for player | calculating and dealing damage.")
				damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
				damage_dealt = damage_dealt.round
				$current_unstable[event_channel.id.to_s]['hp'] -= damage_dealt
			end
		end
		#stores the player that did damage in the unstable array with their damage dealt
		if $current_unstable[event_channel.id.to_s].has_key?('players')
			debug(44, "[HIT] Monster has players array.")
			if $current_unstable[event_channel.id.to_s]['players'].has_key?(event_user.id.to_s)
				debug(46, "[HIT] Key exists for player | adding damage dealt and name to player arrays.")
				$current_unstable[event_channel.id.to_s]['players'][event_user.id.to_s] += damage_dealt
				$current_unstable[event_channel.id.to_s]['players2'][event_user.id.to_s] = event_user.name
			else
				debug(50, "[HIT] Key doesn't exist for player | Creating it and seting damage dealt.")
				$current_unstable[event_channel.id.to_s]['players'][event_user.id.to_s] = damage_dealt
				$current_unstable[event_channel.id.to_s]['players2'][event_user.id.to_s] = event_user.name
			end
		else
			debug(55, "[HIT] Monster does not have players array | Creating it and adding player damage and name.")
			$current_unstable[event_channel.id.to_s]['players'] = {"#{event_user.id}"=>damage_dealt}
			$current_unstable[event_channel.id.to_s]['players2'] = {"#{event_user.id}"=>event_user.name}
		end
		#checks if the monster is dead and displays end results if it is
		if $current_unstable[event_channel.id.to_s]['hp'] < 0
			debug(61, "[HIT] Monster is dead | Generating and displaying results.")
			end_results = $current_unstable[event_channel.id.to_s]
			$current_unstable = $current_unstable.without(event_channel.id.to_s)
			killed_log(event_channel.id.to_s, end_results['name'])
			begin
				event_channel.send_embed 'The monster has been killed! Here are the results:', hunt_end(end_results)
			rescue
				mute_log(event_channel.id.to_s)
			end
		end
	end
end
