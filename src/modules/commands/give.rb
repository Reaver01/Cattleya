module Bot
  module Commands
    # Command Name
    module GiveItem
      extend Discordrb::Commands::CommandContainer
      command(
        :give
      ) do |event|
        Database::Player.resolve_id(event.user.id).add_item id: 1
      end
    end
  end
end
