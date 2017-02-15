module Bot
  module Events
    # Message event
    module Message
      extend Discordrb::EventContainer
      message do |event|
        if event.message.channel.pm?
        else
          unless event.message.content.include?(PREFIX)
            # gain xp
            # revive if dead
            # damage player
            # check if in trap
            # check if still angry
            # hit the monster
            # raise anger
          end
        end
      end
    end
  end
end
