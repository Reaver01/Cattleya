module Game
  # Allows an object to have a dynamic inventory
  module Inventory
    # Returns the inventory or an empty array if there is nothing in the
    # inventory.
    def inventory
      @inventory ||= []
    end

    # Returns the amount of the specified item or 0 if item does not exist in
    # the invenory.
    def item(id)
      @inventory[id] || 0
    end

    # Adds one of the specified item into the inventory.
    def add_item(id)
      @inventory[id] = item(id) + 1
    end

    # Removes one of the specified item from the inventory.
    # If no items of that id exist in the inventory it will stay at zero
    def remove_item(id)
      @inventory[id] = if item(id) <= 1
                         0
                       else
                         item(id) - 1
                       end
    end

    # Used to set the quantity directly of the specified item.
    def set_item(id, quantity)
      @inventory[id] = quantity
    end
  end

  # Allows an object to have hitpoints and be attacked by players.
  module Hitpoints
    # Used to attack the object. Called by attacked
    class Attack
      attr_reader :id

      attr_reader :attacker

      attr_reader :damage

      def initialize(id: nil, damage: 1, attacker: nil)
        if attacker
          @attacker = attacker
          @id = attacker.id
        end

        @id ||= id
        @damage = damage
      end
    end

    # Returns the objects remaining health, or sets the objects health to a
    # specific value.
    def hp(set = nil)
      return @hp ||= 1 unless set
      @hp = set
    end

    # Used to determine if the object is dead.
    def dead?
      @hp <= 0
    end

    # Used to determine if the object is alive.
    def alive?
      @hp > 0
    end

    # Shows an id array of all the attacks made on the object.
    def attacks
      @attacks ||= []
    end

    # Used to check how much damage has been done by a specified id.
    def damage_from(id)
      attacks_by(id).map(&:damage).reduce(:+)
    end

    # Used to show the ids of all attackers.
    def attacked_ids
      attacks.map(&:id)
    end

    # Used to check if the object was attacked by a specific id.
    def attacked_by?(id)
      attacked_ids.include? id
    end

    # Used to attack an Object with another Object.
    # Monster.attacked(Player, 5) for example will do 5 damage to Player from
    # Monster.
    def attacked(target, damage)
      target.add_attack Attack.new(attacker: self, damage: damage)
    end

    # Used by attacked() to attack something.
    def add_attack(attack)
      attacks
      @attacks << attack
      @hp -= damage
    end
  end

  # Defines the player
  class Player
    include Inventory

    include Hitpoints

    attr_reader :id

    attr_reader :xp

    attr_reader :level

    attr_reader :hr

    attr_reader :zenny

    attr_reader :max_hp

    attr_reader :time

    attr_reader :inventory

    def initialize(id)
      @id = id
      @xp = 0
      @level = 0
      @hr = 0
      @zenny = 100
      @max_hp = 500
      @hp = 500
      @time = Time.now
    end

    # Loads a player object from stored JSON.
    def self.from_json(data)
      new(
        xp: data['xp'],
        level: data['level'],
        hr: data['hr'],
        zenny: data['zenny'],
        max_hp: data['max_hp'],
        hp: data['hp'],
        time: data['time'],
        inventory: data['inventory']
      )
    end
  end

  # Defines a monster and is used to create a new Monster object.
  class Monster
    include Hitpoints

    attr_reader :id

    attr_reader :color

    attr_reader :hp

    attr_reader :icon

    attr_reader :name

    attr_reader :trap

    attr_reader :in_trap

    attr_reader :trap_time

    attr_reader :is_angry

    attr_reader :anger_level

    attr_reader :anger_time

    def initialize(data)
      @id = rand(100_000_000..999_999_999)
      @color = data['color']
      @hp = data['hp']
      @icon = data['icon']
      @name = data['name']
      @trap = data['trap']
      @in_trap = nil
      @trap_time = nil
      @is_angry = nil
      @anger_level = nil
      @anger_time = nil
    end
  end
end
