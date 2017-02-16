module Bot
  module Database
    # Defines a human player of the game.
    class ActiveMonster < Sequel::Model
      many_to_one :monsters
      one_to_many :monster_attackers

      def self.spawn(channel)
        find(channel: channel) || create(channel: channel, monster_id: Database::Monster[rand(1..Database::Monster.count)].id)
      end
    end
  end
end
