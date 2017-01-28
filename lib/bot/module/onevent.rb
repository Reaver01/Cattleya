# Run checks on message event
module Events
  extend Discordrb::EventContainer
  message do |event|
    if event.message.channel.pm?
    else
      unless event.message.content.include?(PREFIX)
        revive(event.user, event.channel, event.timestamp)
        levels(event.user, event.timestamp)
        damage(event.user, event.channel, event.message, event.timestamp)
        trap(event.channel, event.timestamp)
        hit(event.user, event.channel) if event.message.content.include? $hit
        anger(event.channel) if event.message.content.include? $anger
        anger_check(event.channel, event.timestamp)
      end
    end
  end
end
