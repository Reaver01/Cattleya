module Events
	extend Discordrb::EventContainer
	message do |event|
		if event.message.channel.pm?
			#does nothing
		else
			unless event.message.content.include?(PREFIX)
				
			end
		end
	end
end