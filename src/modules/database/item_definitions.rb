module Bot
  module Database
    # Defines a human player of the game.
    class ItemDefinition < Sequel::Model
      one_to_many :items
    end
  end
end
