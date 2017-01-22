module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			unless event.message.content.include?(PREFIX)
				if $current_unstable.has_key?(event.channel.id.to_s)
					if $current_unstable[event.channel.id.to_s].has_key?('damage_time')
						old_time = $current_unstable[event.channel.id.to_s]['damage_time']
					else
						#time in the distant past so it doesn't error
						old_time = '2017-01-01 00:00:00 +0000'
					end
					damaged_players = Hash.new
					if TimeDifference.between(old_time, event.timestamp).in_minutes > 3
						$current_unstable[event.channel.id.to_s]['damage_time'] = event.timestamp
						if $current_unstable[event.channel.id.to_s].has_key?('players')
							$current_unstable[event.channel.id.to_s]['players'].each do |key, value|
								damage_done = 0
								if $current_unstable[event.channel.id.to_s].has_key?('is_dead')
									if $current_unstable[event.channel.id.to_s]['is_dead'].has_key?(key)
										unless $current_unstable[event.channel.id.to_s]['is_dead'][key]
											damage_done = rand(0..value) / 2
										end
									else
										damage_done = rand(0..value) / 2
									end
								else
									damage_done = rand(0..value) / 2
								end
								damage_done = damage_done.round
								unless damage_done == 0
									if $players.has_key?(key)
										if $players[key]['messages']
											begin
												BOT.user(key).pm("You have taken **#{damage_done} damage** from the **#{$current_unstable[event.channel.id.to_s]['name']}** in **#{event.channel.name}**")
											rescue
												mute_log(key)
											end
										end
										unless $players[key].has_key?('max_hp')
											new_hp = 500 + ($players[key]['level'] * 10)
											$players[key]['max_hp'] = new_hp
											$players[key]['current_hp'] = new_hp
										end
									end
									damaged_players[key] = damage_done
								end
							end
							damaged_players.each do |key, value|
								if $players.has_key?(key)
									unless $players[key].has_key?('current_hp')
										new_hp = 500 + ($players[key]['level'] * 10)
										$players[key]['max_hp'] = new_hp
										$players[key]['current_hp'] = new_hp
									end
									$players[key]['current_hp'] -= value
									if $players[key]['current_hp'] < 0
										if $players[key]['messages']
											begin
												BOT.user(key).pm("You have taken too much damage! The felynes will take approximately 5 minutes to restore you to full power.")
											rescue
												mute_log(key)
											end
										end
										unless $current_unstable[event.channel.id.to_s].has_key?('is_dead')
											$current_unstable[event.channel.id.to_s]['is_dead'] = {key=>true}
										else
											$current_unstable[event.channel.id.to_s]['is_dead'][key] = true
										end
										$players[key]['death_time'] = event.timestamp
									end
								end
							end
						end
					end
				end
			end
			if $players.has_key?(event.user.id.to_s)
				if $players[event.user.id.to_s].has_key?('death_time')
					if TimeDifference.between($players[event.user.id.to_s]['death_time'], event.timestamp).in_minutes > 5
						$players[event.user.id.to_s] = $players[event.user.id.to_s].without('death_time')
						if $current_unstable.has_key?(event.channel.id.to_s)
							if $current_unstable[event.channel.id.to_s].has_key?('is_dead')
								$current_unstable[event.channel.id.to_s]['is_dead'][event.user.id.to_s] = false
							else
								$current_unstable[event.channel.id.to_s]['is_dead'] = {event.user.id.to_s=>false}
							end
						end
						$players[event.user.id.to_s]['current_hp'] = $players[event.user.id.to_s]['max_hp']
					end
				end
			end
		end
	end
end