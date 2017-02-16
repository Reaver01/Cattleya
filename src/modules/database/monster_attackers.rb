module Bot
  module Database
    # Defines a human player of the game.
    class MonsterAttackers < Sequel::Model
      many_to_one :active_monster
      many_to_one :player
    end
  end
end
