def anger_check(event_channel, event_timestamp)
	if $current_unstable.has_key?(event_channel.id.to_s)
		if $current_unstable[event_channel.id.to_s].has_key?('angertime')
			if TimeDifference.between($current_unstable[event_channel.id.to_s]['angertime'], event_timestamp).in_minutes > 3
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
