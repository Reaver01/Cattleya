module Bot
  module Events
    # Message event
    module Message
      extend Discordrb::EventContainer
      message do |event|
        # Do nothing if the channel is a DM
        if event.message.channel.pm?
        else
          # Do nothing if the message starts with BOT prefix
          unless event.message.content.start_with?(PREFIX)
            # Store the player
            current_player = Database::Player.resolve_id(event.user.id)

            # Store the monster
            monster = Database::ActiveMonster.current(event.channel.id)

            # Gain xp and store the output
            leveled_up = current_player.add_xp(rand(15..25))

            # Check if the player leveled up and has notifications turned on
            if leveled_up[:leveled_up] && current_player.notifications
              # Send the user a DM about their level up with an embedded item list
              event.user.pm.send_embed('Congratulations! You have leveled up to Level ' \
                "#{current_player.level}\nYou have earned yourself #{leveled_up[:zenny]} " \
                'Zenny and a few items you can trade or use!', leveled_up[:embed])
            end

            # revive if dead and 5 minutes has past

            # Check for a monster
            if monster
              # Damage player

              # Check trap status of monster and set trap_mod
              trap_mod = if monster.trapped?
                           1.75
                         else
                           1
                         end

              # Check if the current player is on carting timeout
              unless current_player.carting?
                # Caluclate final damage value
                damage = rand(0..(10 + current_player.hr)) * trap_mod

                # Add an attack on the monster if the secret letter was used
                monster.add_attack(event.user.id, damage) if event.message.content.include?($hit)
              end

              # Check if the secret anger letter was used
              if event.message.content.include?($anger)
                # Add anger (Returns true if monster is engraged)
                if monster.add_anger
                  # Send a message to the channel that monster is enraged
                  event.respond "The #{monster.monster.name} has become enraged!"

                  # Set up a reminder for when the monster is not enraged
                  reminder_channel(
                    monster.angry_since + 3 * 60, event.channel.id, 'anger',
                    "The #{monster.monster.name} is no longer enraged!"
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
