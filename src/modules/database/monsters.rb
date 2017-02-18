module Bot
  module Database
    # Monster table
    class Monster < Sequel::Model
      one_to_many :active_monsters
    end
  end
end
