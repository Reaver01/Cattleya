module Bot
  module Database
    # Item table
    class Item < Sequel::Model
      many_to_one :player
      many_to_one :item_definition
    end
  end
end
