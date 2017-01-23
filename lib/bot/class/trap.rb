def trap(event_channel, event_timestamp)
	if $current_unstable.has_key?(event_channel.id.to_s)
		if $current_unstable[event_channel.id.to_s].has_key?('traptime')		
			if TimeDifference.between($current_unstable[event_channel.id.to_s]['traptime'], event_timestamp).in_minutes > 2
				$current_unstable[event_channel.id.to_s]['intrap'] = false
				$current_unstable[event_channel.id.to_s] = $current_unstable[event_channel.id.to_s].without('traptime')
				begin
					BOT.channel(event_channel.id.to_s).send_message("The #{$current_unstable[event_channel.id.to_s]['name']} has escaped the trap!")
				rescue
					mute_log(event_channel.id.to_s)
				end
			end
		end
	end
end
