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

            # Store the monster
            monster = Database::ActiveMonster.current(event.channel.id)

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

            # Attack the monster
            trap_mod = if monster.trapped?
                         1.75
                       else
                         1
                       end
            unless current_player.carting?
              damage = rand(0..(10 + current_player.hr)) * trap_mod
              monster.add_attack(event.user.id, damage) if event.message.content.include?($hit)
            end

            # Check if there is a monster in the channel and if it's angry
            if monster && event.message.content.include?($anger)
              if monster.add_anger
                event.respond "The #{monster.monster.name} has become angry!"
                time = monster.angry_since + 3 * 60
                message = "The #{monster.monster.name} is no longer angry!"
                SCHEDULER.at time.to_s, tags: [event.channel.id.to_s] do
                  BOT.channel(event.channel.id).send_message message
                end
              end
            end
          end
        end
      end
    end
  end
end
