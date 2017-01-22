module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			unless event.message.content.include?(PREFIX)
				#checks to see if a monster is in a trap longer than 2 mins and releases it if it is
				if $current_unstable.has_key?(event.channel.id.to_s)
					if $current_unstable[event.channel.id.to_s].has_key?('traptime')		
						if TimeDifference.between($current_unstable[event.channel.id.to_s]['traptime'], event.timestamp).in_minutes > 2
							$current_unstable[event.channel.id.to_s]['intrap'] = false
							$current_unstable[event.channel.id.to_s] = $current_unstable[event.channel.id.to_s].without('traptime')
							begin
								event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has escaped the trap!"
							rescue
								mute_log(event.channel.id.to_s)
							end
						end
					end
				end
			end
		end
	end
end
