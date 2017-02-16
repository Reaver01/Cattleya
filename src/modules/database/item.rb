module Bot
  module Database
    # Defines a human player of the game.
    class Item < Sequel::Model
      many_to_one :player
      many_to_one :item_definition
    end
  end
end
