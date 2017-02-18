module Bot
  module Commands
    # Command Name
    module Inventory
      extend Discordrb::Commands::CommandContainer
      command(
        [:inventory, :inv],
        description: 'DMs your inventory'
      ) do |event|
        # Stores the current player
        player = Database::Player.resolve_id(event.user.id)

        # Sends a DM with the players ineventory
        begin
          event.user.pm.send_embed('', player.inventory_embed)
        rescue
          puts 'Failed to send an inventory embed to a player'
        end

        # Deletes the invoking message
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
