require 'titleize'

module Bot
  module Commands
    # Command Module
    module Buy
      extend Discordrb::Commands::CommandContainer
      command(
        [:buy, :b],
        description: 'Buys an item from the shop',
        usage: 'buy <*amount*> <Item Name>',
        min_args: 1
      ) do |event, amount, *item_name|
        # Join item name args and titleize them
        item_name = item_name.join(' ').titleize

        # Check if the item had an s on the end
        if item_name.ends_with?('s') && item_name != 'Mega Nutrients'
          item_name = item_name.chomp('s')
        end

        # Check if the amount as an integer is zero
        if amount.to_i < 1
          # It's probably a stringt then add it to item name
          item_name = amount.to_s + item_name

          # Titleize it again
          item_name = item_name.titleize

          # Set new amount to 1
          amount = 1
        end

        # Make sure our amount is an integer
        amount = amount.to_i

        # Find the item in the database and store it
        current_item = Database::ItemDefinition.find(name: item_name)

        # Find the player in the database and store it
        current_player = Database::Player.resolve_id(event.user.id)

        # Check if the item actually exists
        if current_item.nil?
          # Tell us about it
          begin
            event.channel.send_temporary_message 'That item does not exist', 60
          rescue
            puts 'Failed to send message about item not existing'
          end

        # Check if the player has enough zenny
        elsif current_player.zenny > current_item.price * amount
          # If there is more than one make sure we use an 's'
          plural = if amount > 1
                     's'
                   else
                     ''
                   end

          # Buy the item for the player
          current_player.buy_item(current_item, amount)

          # Remove the cost from the players zenny
          current_player.remove_zenny(current_item.price * amount)

          # Let the channel know that the player bought something
          begin
            event.channel.send_temporary_message "**#{event.user.name}** bought **#{amount} " \
              "#{item_name}#{plural}**", 60
          rescue
            puts 'Failed to send a message with how much a player bought'
          end
        else
          # Let the channel know the player can't afford what they are trying to buy
          begin
            event.channel.send_temporary_message 'You cannot afford that!', 60
          rescue
            puts 'Failed to tell a player they cannot afford something'
          end
        end
        event.message.delete unless event.message.channel.pm?
      end
    end
  end
end
