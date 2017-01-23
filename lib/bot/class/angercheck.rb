def anger_check(event_channel, event_timestamp)
	if $current_unstable.has_key?(event_channel.id.to_s)
		debug(3, "[ANGERCHECK] Channel has a monster in it.")
		if $current_unstable[event_channel.id.to_s].has_key?('angertime')
			debug(5, "[ANGERCHECK] Monster has angertime key.")
			if TimeDifference.between($current_unstable[event_channel.id.to_s]['angertime'], event_timestamp).in_minutes > 3
				debug(7, "[ANGERCHECK] angertime has been longer than 3 minutes | Setting angry to false and removing angertime")
				$current_unstable[event_channel.id.to_s]['angry'] = false
				$current_unstable[event_channel.id.to_s] = $current_unstable[event_channel.id.to_s].without('angertime')
				begin
					event.respond "The #{$current_unstable[event_channel.id.to_s]['name']} is no longer angry!"
				rescue
					mute_log(event_channel.id.to_s)
				end
			end
		end
	end
end
