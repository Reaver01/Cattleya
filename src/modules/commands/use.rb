require 'titleize'

module Bot
  module Commands
    # Command Name
    module Use
      extend Discordrb::Commands::CommandContainer
      command(
        :use
      ) do |event, *item_name|
        # Store the current player to use later
        player = Database::Player.resolve_id(event.user.id)

        # Store the monster
        monster = Database::ActiveMonster.current(event.channel.id)

        # Store last item in the item array as a user name to check if they are using it on someone
        user_name = item_name[-1]

        # # Store everything but the last item in the array as the item if it contains a mention
        item_name = item_name.first item_name.size - 1 unless BOT.parse_mention(user_name).nil?

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
        elsif current_item.can_throw
          # Tell us about it
          response << "You must throw this item!\n"

        # Check if the player has the item
        elsif player.item?(current_item) && player.item_amount(current_item).positive?
          # Store mentioned user name as a string or a blank string
          mentioned = if BOT.parse_mention(user_name).nil?
                        ''
                      else
                        " on **#{user_name}**"
                      end

          # Tell the channel about the player using an item
          response << "**#{event.user.name}** used a **#{item_name}** #{mentioned}!\n"

          # Remove the item from the players inventory
          player.remove_item(current_item)

          # Check if there is a monster and there was no player mentioned
          if monster && BOT.parse_mention(user_name).nil?
            # Check if the used item is a Trap and the monster can be trapped by that type
            if item_name == 'Pitfall Trap' && monster.monster.trapped_by_fall
              # Trap the monster
              monster.become_trapped

              # Tell the channel The monster has been trapped
              response << "The **#{monster.monster.name}** has been trapped\n"
            elsif item_name == 'Shock Trap' && monster.monster.trapped_by_shock
              # Trap the monster
              monster.become_trapped

              # Tell the channel The monster has been trapped
              response << "The **#{monster.monster.name}** has been trapped\n"
            end
          end
        else
          # Tell the channel the player doesn't have the item
          response << "You do not have that item!\n"
        end

        begin
          event.channel.send_temporary_message response, 60
        rescue
          puts 'Failed to respond to use command'
        end
        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
