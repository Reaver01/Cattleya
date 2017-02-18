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
              begin
                event.user.pm.send_embed('Congratulations! You have leveled up to Level ' \
                  "#{current_player.level}\nYou have earned yourself #{leveled_up[:zenny]} " \
                  'Zenny and a few items you can trade or use!', leveled_up[:embed])
              rescue
                puts 'Failed to DM a player with level up notice'
              end
            end

            # Check for a monster
            if monster
              # Check if the secret anger letter was used
              if event.message.content.include?($anger)
                # Add anger (Returns true if monster is engraged)
                if monster.add_anger
                  # Send a message to the channel that monster is enraged
                  begin
                    event.channel.send_temporary_message "The #{monster.monster.name} has become " \
                      'enraged!', 30
                  rescue
                    puts 'Failed to message a channel that a monster is enraged'
                  end

                  # Set up a reminder for when the monster is not enraged
                  reminder_channel(
                    monster.angry_since + 3 * 60, event.channel.id, 'anger',
                    "The #{monster.monster.name} is no longer enraged!"
                  )
                end
              end

              # Check trap status of monster and set trap_mod
              trap_mod = if monster.trapped?
                           1.75
                         else
                           1
                         end

              # Check anger status of monster and set anger_mod
              anger_mod = if monster.angry?
                            2
                          else
                            1
                          end

              # Check anger status and modify our chance to hit
              chance = if monster.angry?
                         19
                       else
                         39
                       end

              # Check if the current player is on carting timeout
              unless current_player.carting?
                # Caluclate final damage value
                damage = rand(0..(10 + current_player.hr)) * trap_mod

                # Add an attack on the monster if the secret letter was used
                monster.add_attack(event.user.id, damage) if event.message.content.include?($hit)

                # Roll the dice
                if rand(0..chance).zero?
                  # Grab the amount of damage the player has done to the monster
                  damage_done = monster.damage_by(event.user.id)&.damage_done || 0

                  # Generate a random number from 0 and that and multiplly it by our anger mod
                  incoming_damage = rand(0..damage_done) * anger_mod

                  # If the generated damage is zero don't do anything
                  unless incoming_damage.zero?
                    # React to the message that caused the damage
                    event.message.react('💥')

                    # Check if player has notifications on
                    if current_player.notifications
                      # Send a DM with damage amount and monster name
                      begin
                        event.user.pm "You have taken **#{incoming_damage} damage** from the " \
                          "**#{monster.monster.name}**"
                      rescue
                        puts 'Failed to DM a player that they took damage'
                      end
                    end

                    # Deal the damage to the player
                    current_player.add_damage(incoming_damage)

                    # Check if player is dead
                    if current_player.dead?

                      # Set death time
                      time_of_death = current_player.died

                      # Reset players health to max
                      current_player.set_hp_to_max

                      # Send a DM to the player with innformation about their demise
                      begin
                        event.user.pm('You have taken too much damage! The felynes will take appr' \
                          'oximately 5 minutes to restore you to full power')
                      rescue
                        puts 'Failed to DM a player that they are dead'
                      end

                      # Set up a reminder for when the player can damage monsters again
                      reminder_dm(time_of_death, event.user.id, 'death', 'You have been restored ' \
                        'to full fighting power! You will be able to damage monsters once again!')
                    end
                  end
                end
              end

              # Check if monster is dead
              if monster.hp < 1
                # Send death embed to channel
                begin
                  event.channel.send_temporary_message(
                    'The monster has been killed! Here are the results:', 30, nil,
                    monster.death_embed
                  )
                rescue
                  puts 'Failed to send a channel an embed about the monster being killed'
                end

                # Give players HR for killing
                monster.give_hr

                # Move the monster to the graveyard
                monster.move_to_graveyard
              end
            end
          end
        end
      end
    end
  end
end
