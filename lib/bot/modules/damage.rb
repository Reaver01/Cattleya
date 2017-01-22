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
					if TimeDifference.between(old_time, event.timestamp).in_seconds > 45
						
					end
				end
			end
		end
	end
end