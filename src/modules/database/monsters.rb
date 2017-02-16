module Bot
  module Database
    # Defines a human player of the game.
    class Monster < Sequel::Model
      one_to_many :active_monsters
    end
  end
end
