module Bot
  module Events
    # Message event
    module Message
      extend Discordrb::EventContainer
      message do |event|
        if event.message.channel.pm?
        else
          unless event.message.content.include?(PREFIX)
            # Store the player
            current_player = Database::Player.resolve_id(event.user.id)

            # Gain xp and store the output
            leveled_up = current_player.add_xp(rand(15..25))

            # Send a notification if the player leveled up and has notifications turned on
            if leveled_up[0] && current_player.notifications
              event.user.pm.send_embed('Congratulations! You have leveled up to Level ' \
                "#{current_player.level}\nYou have earned yourself #{leveled_up[1]} " \
                'Zenny and a few items you can trade or use!', leveled_up[2])
            end

            # revive if dead and 5 minutes has past
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
