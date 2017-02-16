module Bot
  module Events
    # Message event
    module Message
      extend Discordrb::EventContainer
      message do |event|
        if event.message.channel.pm?
        else
          unless event.message.content.include?(PREFIX)
            # Gain xp and send a pm to the player if they want notifications
            if Database::Player.resolve_id(event.user.id).add_xp(rand(15..25))[0]

            end
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
