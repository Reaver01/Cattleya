def damage(event_user, event_channel, event_message, event_timestamp)
	if $current_unstable.has_key?(event_channel.id.to_s)
		if $current_unstable[event_channel.id.to_s].has_key?('damage_time')
			old_time = $current_unstable[event_channel.id.to_s]['damage_time']
		else
			#time in the distant past so it doesn't error
			old_time = '2017-01-01 00:00:00 +0000'
		end
		damaged_players = Hash.new
		if TimeDifference.between(old_time, event_timestamp).in_minutes > 3
			debug("[DAMAGE] Time between damage on #{event_channel.id} is longer than 3 minutes. Changing timestamp and dealing damage.")
			$current_unstable[event_channel.id.to_s]['damage_time'] = event_timestamp
			if $current_unstable[event_channel.id.to_s].has_key?('players')
				debug("[DAMAGE] Players have damaged monster. Adding reaction.")
				event_message.react("🎯")
				$current_unstable[event_channel.id.to_s]['players'].each do |key, value|
					damage_done = 0
					if $current_unstable[event_channel.id.to_s].has_key?('is_dead')
						debug("[DAMAGE] is_dead exists. | Checking for key")
						if $current_unstable[event_channel.id.to_s]['is_dead'].has_key?(key)
							debug("[DAMAGE] key for is_dead exists. | Checking if key = false")
							unless $current_unstable[event_channel.id.to_s]['is_dead'][key]
								debug("[DAMAGE] key = false | #{key} is not dead. Dealing #{damage_done} damage.")
								damage_done = rand(0..value) / 2
							end							
						else
							debug("[DAMAGE] key for is_dead doesn't exist | #{key} is not dead. Dealing #{damage_done} damage.")
							damage_done = rand(0..value) / 2
						end
					else
						debug("[DAMAGE] is_dead doesn't exist | Nobody is dead. Dealing #{damage_done} damage.")
						damage_done = rand(0..value) / 2
					end
					damage_done = damage_done.round
					unless damage_done == 0
						debug("[DAMAGE] Damage was done | Notifying player.")
						if $players.has_key?(key)
							if $players[key]['messages']
								debug("[DAMAGE] Player has messages turned on | Continuing with message.")
								begin
									BOT.user(key).pm("You have taken **#{damage_done} damage** from the **#{$current_unstable[event_channel.id.to_s]['name']}** in **#{event_channel.name}**")
								rescue
									mute_log(key)
								end
							end
							unless $players[key].has_key?('max_hp')
								debug("[DAMAGE] Player doesn't have an HP value in their profile | calculating HP for player.")
								new_hp = 500 + ($players[key]['level'] * 10)
								$players[key]['max_hp'] = new_hp
								$players[key]['current_hp'] = new_hp
							end
						end
						debug("[DAMAGE] Adding player id and damage done to array.")
						damaged_players[key] = damage_done
					end
				end
				damaged_players.each do |key, value|
					if $players.has_key?(key)
						debug("[DAMAGE] Player has profile")
						unless $players[key].has_key?('current_hp')
							debug("[DAMAGE] Player doesn't have an HP value in their profile | calculating HP for player.")
							new_hp = 500 + ($players[key]['level'] * 10)
							$players[key]['max_hp'] = new_hp
							$players[key]['current_hp'] = new_hp
						end
						$players[key]['current_hp'] -= value
						if $players[key]['current_hp'] < 0
							debug("[DAMAGE] Player's health < 0 | Player is dead.")
							if $players[key]['messages']
								debug("[DAMAGE] Player has messages turned on | Continuing with message.")
								begin
									BOT.user(key).pm("You have taken too much damage! The felynes will take approximately 5 minutes to restore you to full power.")
								rescue
									mute_log(key)
								end
							end
							unless $current_unstable[event_channel.id.to_s].has_key?('is_dead')
								debug("[DAMAGE] Player doesn't already have a key in is_dead | Making a key.")
								$current_unstable[event_channel.id.to_s]['is_dead'] = {key=>true}
							else
								debug("[DAMAGE] Player has a key in is_dead | Setting key to true.")
								$current_unstable[event_channel.id.to_s]['is_dead'][key] = true
							end
							debug("[DAMAGE] adding death_time to player profile.")
							$players[key]['death_time'] = event_timestamp
						end
					end
				end
			end
		end
	end
	if $players.has_key?(event_user.id.to_s)
		debug("[DAMAGE] Player has profile.")
		if $players[event_user.id.to_s].has_key?('death_time')
			debug("[DAMAGE] Player has key for death_time.")
			if TimeDifference.between($players[event_user.id.to_s]['death_time'], event_timestamp).in_minutes > 5
				debug("[DAMAGE] death_time was > 5 minutes ago | Removing key from death_time.")
				$players[event_user.id.to_s] = $players[event_user.id.to_s].without('death_time')
				if $current_unstable.has_key?(event_channel.id.to_s)
					debug("[DAMAGE] There is a monster in the current channel.")
					if $current_unstable[event_channel.id.to_s].has_key?('is_dead')
						debug("[DAMAGE] Key for is_dead exists | Reviving player")
						$current_unstable[event_channel.id.to_s]['is_dead'][event_user.id.to_s] = false
					else
						debug("[DAMAGE] Key for is_dead does not exist | Making one and setting player to not dead.")
						$current_unstable[event_channel.id.to_s]['is_dead'] = {event_user.id.to_s=>false}
					end
				end
				debug("[DAMAGE] Setting player's health to max.")
				$players[event_user.id.to_s]['current_hp'] = $players[event_user.id.to_s]['max_hp']
			end
		else
			if $current_unstable.has_key?(event_channel.id.to_s)
				debug("[DAMAGE] Player does not have a key for death time.")
				if $current_unstable[event_channel.id.to_s].has_key?('is_dead')
					debug("[DAMAGE] Key exists for is_dead | Reviving player.")
					$current_unstable[event_channel.id.to_s]['is_dead'][event_user.id.to_s] = false
				else
					debug("[DAMAGE] Key doesn't exist for is_dead | Creating one and reviving player.")
					$current_unstable[event_channel.id.to_s]['is_dead'] = {event_user.id.to_s=>false}
				end
			end
			debug("[DAMAGE] Setting player's health to max.")
			$players[event_user.id.to_s]['current_hp'] = $players[event_user.id.to_s]['max_hp']
		end
	end
end
