module Events
	extend Discordrb::EventContainer
	message(containing: $anger) do |event|
		if event.message.channel.pm?
			#does nothing
		else
			unless event.message.content.include?(PREFIX)
				if $current_unstable.has_key?(event.channel.id.to_s)
					unless $current_unstable[event.channel.id.to_s].has_key?('angry')
						$current_unstable[event.channel.id.to_s]['angry'] = false
					end
					unless $current_unstable[event.channel.id.to_s]['angry']
						if $current_unstable[event.channel.id.to_s].has_key?('anger')
							$current_unstable[event.channel.id.to_s]['anger'] += 1
						else
							$current_unstable[event.channel.id.to_s]['anger'] = 1
						end
						if $current_unstable[event.channel.id.to_s]['anger'] > 50
							$current_unstable[event.channel.id.to_s]['angry'] = true
							$current_unstable[event.channel.id.to_s]['angertime'] = Time.now
							$current_unstable[event.channel.id.to_s]['anger'] = 0
							begin
								event.respond "The #{$current_unstable[event.channel.id.to_s]['name']} has become angry!"
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