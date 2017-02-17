module Bot
  module Commands
    # Command Name
    module Inventory
      extend Discordrb::Commands::CommandContainer
      command(
        [:inventory, :inv],
        description: 'DMs your inventory'
      ) do |event|
        player = Database::Player.resolve_id(event.user.id)
        event.user.pm.send_embed('', player.inventory_embed)
        event.message.delete unless event.message.channel.pm?
        nil
      end
    end
  end
end
