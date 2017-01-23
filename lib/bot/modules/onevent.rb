module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			unless event.message.content.include?(PREFIX)
				levels(event.user, event.timestamp)
				damage(event.user, event.channel, event.timestamp)
				trap(event.channel, event.timestamp)
				if event.message.content.include? $hit
					hit(event.user, event.channel)
				end
				if event.message.content.include? $anger
					anger(event.channel)
				end
				anger_check(event.channel, event.timestamp)
			end
		end
	end
end
