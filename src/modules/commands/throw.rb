require 'titleize'

module Bot
  module Commands
    # Command Name
    module Throw
      extend Discordrb::Commands::CommandContainer
      command(
        :throw
      ) do |event, *item_name|
        # Store the current player to use later
        player = Database::Player.resolve_id(event.user.id)

        # Store the monster
        monster = Database::ActiveMonster.current(event.channel.id)

        # Store last item in the item array as a user name to check if they are using it on someone
        user_name = item_name[-1]

        # # Store everything but the last item in the array as the item if it contains a mention
        item_name = item_name.first item.size - 1 unless BOT.parse_mention(user_name).nil?

        # Store it as a string and titleize it
        item_name = item_name.join(' ').titleize

        # Grab the item if it exists from the database and store it
        current_item = Database::ItemDefinition.find(name: item_name)

        # Establish response message
        response = ''

        if current_item.nil?
          # Tell us about it
          response << "That item does not exist\n"

        # Check if item is a thrown item
        elsif !current_item.can_throw
          # Tell us about it
          response << "You cannot throw this item!\n"

        # Check if the player has the item
        elsif player.item?(current_item) && player.item_amount(current_item).positive?
          # Store mentioned user name as a string or a blank string
          mentioned = if BOT.parse_mention(user_name).nil?
                        ''
                      else
                        " on **#{user_name}**"
                      end

          # Tell the channel about the player throwing an item
          response << "**#{event.user.name}** threw a **#{item_name}** #{mentioned}!\n"

          # Remove the item from the players inventory
          player.remove_item(current_item)

          # Check if there is a monster and there was no player mentioned
          if monster && BOT.parse_mention(user_name).nil?
            # Set initial values
            damage = 0
            hit_chance = nil
            dung = false

            # Check if the item was a damage dealing item and store
            if item_name == 'Barrel Bomb S'
              damage = 20
              hit_chance = 2
            elsif item_name == 'Barrel Bomb L'
              damage = 40
              hit_chance = 1
            elsif item_name == 'Dynamite'
              damage = 15
              hit_chance = 3
            elsif item_name == 'Pickaxe'
              damage = 5
              hit_chance = 1
            elsif item_name == 'Dung Bomb'
              damage = 0
              hit_chance = 3
              dung = true
            end

            # Check if there is a chance to hit
            if hit_chance
              # Modify hit chance based on trap status
              hit_chance = if monster.trapped?
                             0
                           else
                             hit_chance
                           end

              # Check if the monster was hit
              if rand(0..hit_chance).zero?
                # Add attack if damage is a positive Integer
                monster.add_attack(event.user.id, damage) if damage.positive?

                # Tell the channel about the monster hit
                response << "**#{event.user.name}** hit the **#{monster.monster.name}** with a **" \
                  "#{item_name}**!\n"

                # Check if the item that hit was dung
                if dung
                  # Initialize array
                  empty_channels = []

                  # Store channels without a monster in the array
                  Database::UnstableChannel.each do |channel|
                    # Skip if channel isn't unstable
                    next unless channel.unstable

                    # Check if there is a monster in the channel
                    next if Database::ActiveMonster.current(channel.channel_id)

                    # Push the id to the array
                    empty_channels.push(channel.channel_id)
                  end

                  if empty_channels.length.zero?
                    # Tell the channel about the monster having nowhere to go
                    response << "There are no channels for the monster to go!\n"
                  else
                    # Store a random empty channel
                    new_channel = empty_channels.sample

                    # Move the monster to the new channel
                    monster.move_to(new_channel)

                    # Tell the new channel about the monster
                    begin
                      BOT.channel(new_channel).send_embed(
                        "A Monster has entered the channel!\nThis monster came from " \
                        "**#{event.channel.name}** via a Dung Bomb!",
                        monster.initial_embed
                      )
                    rescue
                      puts 'Moving monster failed'
                    end
                    # Tell the channel about the monster moving
                    response << "The monster has moved to **#{BOT.channel(new_channel).name}**\n"
                  end

                end
              else
                # Tell the channel about missing the monster
                response << "**#{event.user.name}** missed!\n"
              end
            end
          end

        else
          # Tell the channel the player doesn't have the item
          response << "You do not have that item!\n"
        end

        begin
          event.channel.send_temporary_message response, 60
        rescue
          puts 'Failed to respond to throw command'
        end
        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
