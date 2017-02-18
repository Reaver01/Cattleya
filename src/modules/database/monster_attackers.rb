module Bot
  module Database
    # Monster Attacker table
    class MonsterAttacker < Sequel::Model
      many_to_one :active_monster
      many_to_one :player
    end
  end
end
