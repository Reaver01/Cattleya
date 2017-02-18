module Bot
  module Database
    # Item Definition table
    class ItemDefinition < Sequel::Model
      one_to_many :items
    end
  end
end
