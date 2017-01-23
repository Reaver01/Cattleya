def hit(event_user, event_channel)
	if $current_unstable.has_key?(event_channel.id.to_s)
		#checks if the monster is in a trap and modifies damage if it is
		if $current_unstable[event_channel.id.to_s].has_key?('intrap')
			if $current_unstable[event_channel.id.to_s]['intrap']
				trap_modifier = 1.75
			else
				trap_modifier = 1
			end
		else
			trap_modifier = 1
		end
		#checks players hr and modifies damage
		unless $players.has_key?(event_user.id.to_s)
			hr_modifier = 0
		else
			hr_modifier = $players[event_user.id.to_s]['hr']
		end
		#final damage dealt calculated and rounded to integer
		damage_dealt = 0
		if $current_unstable[event_channel.id.to_s].has_key?('is_dead')
			if $current_unstable[event_channel.id.to_s]['is_dead'].has_key?(event_user.id.to_s)
				unless $current_unstable[event_channel.id.to_s]['is_dead'][event_user.id.to_s]
					damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
					damage_dealt = damage_dealt.round
					$current_unstable[event_channel.id.to_s]['hp'] -= damage_dealt
				else
					if $debug
						puts "#{event_user.id} is dead and can't deal damage"
					end
				end
			else
				damage_dealt = rand(0..(10 + hr_modifier)) * trap_modifier
				damage_dealt = damage_dealt.round
				$current_unstable[event_channel.id.to_s]['hp'] -= damage_dealt
			end
		end
		#stores the player that did damage in the unstable array with their damage dealt
		if $current_unstable[event_channel.id.to_s].has_key?('players')
			if $current_unstable[event_channel.id.to_s]['players'].has_key?(event_user.id.to_s)
				$current_unstable[event_channel.id.to_s]['players'][event_user.id.to_s] += damage_dealt
				$current_unstable[event_channel.id.to_s]['players2'][event_user.id.to_s] = event_user.name
			else
				$current_unstable[event_channel.id.to_s]['players'][event_user.id.to_s] = damage_dealt
				$current_unstable[event_channel.id.to_s]['players2'][event_user.id.to_s] = event_user.name
			end
		else
			$current_unstable[event_channel.id.to_s]['players'] = {"#{event_user.id}"=>damage_dealt}
			$current_unstable[event_channel.id.to_s]['players2'] = {"#{event_user.id}"=>event_user.name}
		end
		#checks if the monster is dead and displays end results if it is
		if $current_unstable[event_channel.id.to_s]['hp'] < 0
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
