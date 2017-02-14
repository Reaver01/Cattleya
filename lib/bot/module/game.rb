module Game
  # Mixin that allows an object to have a dynamic inventory
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

  # Mixin that allows an object to be attacked by other objects.
  # Object must have hp to be attacked!
  module Hitpoints
    # Used to attack the object. Called by attacked. (Do not call from outside!)
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

    # Returns true if the object is dead.
    def dead?
      @hp <= 0
    end

    # Returns true if the object is alive.
    def alive?
      @hp > 0
    end

    # Shows an id array of all the attacks made on the object.
    def attacks
      @attacks ||= []
    end

    # Lists all of the attacks by defined id
    def attacks_by(id = nil)
      @attacks.select { |a| a.id == id }
    end

    # Checks how much damage has been done by a specified id.
    def damage_from(id)
      attacks_by(id).map(&:damage).reduce(:+)
    end

    # Shows the ids of all attackers.
    def attacked_ids
      attacks.map(&:id)
    end

    # Checks if the object was attacked by a specific id.
    def attacked_by?(id)
      attacked_ids.include? id
    end

    # Attacks an Object with another Object.
    # Monster.attacked(Player, 5) for example will do 5 damage to Player from
    # Monster.
    def attacked(target, damage)
      target.add_attack(Attack.new(attacker: self, damage: damage))
    end

    # Used by attacked() to attack something. (Do not call ouside!)
    def add_attack(attack)
      attacks
      @attacks << attack
      @hp -= attack.damage
    end
  end

  # Mixin that allows objects to have levels with scaling health.
  module Levels
    # Returns objects level or zero if not set.
    def level
      @level ||= 0
    end

    # Returns objects experience or zero if not set.
    def xp
      @xp ||= 0
    end

    # Returns objects max health or 500 if not set.
    def max_hp
      @max_hp ||= 500
    end

    # Returns objects health or it's max health if not set.
    def hp
      @hp ||= @max_hp
    end

    # Checks xp required for next level based on current level using a way too
    # complicated level curve algorithm.
    def next_level
      0.8333333333 * (@level - 1) * (2 * @level ^ 2 + 23 * @level + 66)
    end

    # Checks if the object has enough xp to level up.
    def enough_xp?
      @xp > next_level
    end

    # Adds a specified amount of xp to the object.
    def add_xp(amount)
      @xp += amount
      if enough_xp?
        level_up
        true
      else
        false
      end
    end

    # Levels up the object!  (Do not call ouside!)
    def level_up
      @level += 1
      raise_max_hp
    end

    # Raises max HP of the object. (Do not call ouside!)
    def raise_max_hp
      @max_hp += 10
      set_hp_to_max
    end

    # Sets objects health back to max.
    def set_hp_to_max
      @hp = @max_hp
    end
  end

  # Mixin that allows objects to become angry.
  module Anger
    def anger_level
      @anger_level ||= 0
    end

    # Returns the last time the object started being angry.
    def angry_since
      @angry_since ||= Time.new '2017'
    end

    # Returns the amount of minutes since the object last started being angry.
    def angry_for
      TimeDifference.between(@angry_since, Time.now).in_minutes
    end

    # Returns true until the amount of minutes since the object last started
    # being angry is greater than 3 minutes.
    def angry?
      angry_for < 3
    end

    # Adds a specified amount to the objects anger level or 1 if none specified.
    # Anger level will not rise if the object is already angry.
    def add_anger(amount = 1)
      @anger_level += amount unless angry?
      become_angry if anger_level > 50
    end

    # Drops the anger level back down to 0 so the object can start being angry
    # again when it's no longer angry.
    # Sets angry_since to the current time.
    def become_angry
      @anger_level = 0
      @angry_since = Time.now
    end
  end

  # Mixin to allow objects to be trapped
  module Trap
    # Returns the last time the object was trapped.
    def trapped_since
      @trapped_since ||= Time.new '2017'
    end

    # Returns the amount of minutes since the object was last trapped.
    def trapped_for
      TimeDifference.between(@trapped_since, Time.now).in_minutes
    end

    # Returns true if it has been longer than 2 minutes since the object was
    # last trapped.
    def trap_expired?
      trapped_for > 2
    end

    # Sets the trapped_since variable to the current time causing trap_expired
    # to return false for the next 2 minutes.
    def become_trapped
      @trapped_since = Time.now
    end
  end

  # Defines a human player of the game. Must be initialized using a unique
  # player id. (usually the users id from discord)
  class Player
    include Inventory

    include Hitpoints

    include Levels

    attr_reader :id

    attr_reader :hr

    attr_reader :zenny

    attr_reader :time

    attr_reader :death_time

    def initialize(id)
      @id = id
      @hr = 0
      @level = 0
      @xp = 0
      @max_hp = 500
      @zenny = 100
      @inventory = []
      @time = Time.now
      @death_time = Time.new '2017'
    end

    # Loads a player object from stored JSON. (This will soon be deprecated)
    def self.from_json(data)
      new(
        xp: data['xp'],
        level: data['level'],
        hr: data['hr'],
        zenny: data['zenny'],
        max_hp: data['max_hp'],
        hp: data['hp'],
        time: data['time'],
        inventory: data['inventory'],
        death_time: data['death_time'] || Time.new('2017')
      )
    end
  end

  # Defines a monster and is used to create a new Monster object.
  # Monster must be initialized with a monster hash from MONSTERS (usually
  # MONSTERS.sample) or a custom hash as long as all variables are present in
  # the hash (color, hp, icon, name, trap)
  # an ID will be randomly generated for the new monster.
  class Monster
    include Hitpoints

    include Anger

    include Trap

    attr_reader :id

    attr_reader :color

    attr_reader :hp

    attr_reader :icon

    attr_reader :name

    attr_reader :trap

    def initialize(data)
      @id = rand(100_000_000..999_999_999)
      @color = data['color']
      @hp = data['hp']
      @icon = data['icon']
      @name = data['name']
      @trap = data['trap']
      @trapped_since = Time.new '2017'
      @anger_level = 0
      @angry_since = Time.new '2017'
    end
  end
end
