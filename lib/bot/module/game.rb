module Game
  # Mixin that allows an object to have a dynamic inventory
  module Inventory
    # @return [Array<inventory>] Array of quantities of items in inventory
    def inventory
      @inventory ||= []
    end

    # @param id [Integer] item id
    # @return [Integer] Amount of the item with given id
    def item(id)
      @inventory[id] || 0
    end

    # @param id [Integer] item id
    # @return [Integer] New amount of the item with given id
    def add_item(id)
      @inventory[id] = item(id) + 1
    end

    # @param id [Integer] item id
    # @return [Integer] New amount of the item with given id
    def remove_item(id)
      @inventory[id] = if item(id) <= 1
                         0
                       else
                         item(id) - 1
                       end
    end

    # @param id [Integer] item id
    # @param quantity [Integer] item quantity
    # @return [Integer] Given quantity of the item with given id
    def set_item(id, quantity)
      @inventory[id] = quantity
    end
  end

  # Mixin that allows an object to be attacked by other objects.
  # Object must have hp to be attacked!
  module Hitpoints
    # @param id [Integer] object id
    # @param damage [Integer] damage done
    # @param attacker [Object] object of attacker
    # @return [Integer] damage done to object
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

    # @param set [Integer] new hp value
    # @return [Integer] objects current hp value
    def hp(set = nil)
      return @hp ||= 1 unless set
      @hp = set
    end

    # @return [Boolean] true if dead
    def dead?
      @hp <= 0
    end

    # @return [Boolean] true if alive
    def alive?
      @hp > 0
    end

    # @return [Array] attacks made
    def attacks
      @attacks ||= []
    end

    # @param id [Integer] object id
    # @return [Array] attacks by id
    def attacks_by(id = nil)
      @attacks.select { |a| a.id == id }
    end

    # @param id [Integer] object id
    # @return [Integer] damage done by id
    def damage_from(id)
      attacks_by(id).map(&:damage).reduce(:+)
    end

    # @return [Array] attacks by id
    def attacked_ids
      attacks.map(&:id)
    end

    # @param id [Integer] object id
    # @return [Boolean] true if attacked by id
    def attacked_by?(id)
      attacked_ids.include? id
    end

    # @param target [Object] target object
    # @param damage [Integer] damage done
    # @return [Integer] New hp value of target
    def attacked(target, damage)
      target.add_attack(Attack.new(attacker: self, damage: damage))
    end

    # @param attack [Object] new attack object
    # @return [Integer] New hp value
    def add_attack(attack)
      attacks
      @attacks << attack
      @hp -= attack.damage
    end
  end

  # Mixin that allows objects to have levels with scaling health.
  module Levels
    # @return level [Integer] current level
    def level
      @level ||= 0
    end

    # @return xp [Integer] current xp
    def xp
      @xp ||= 0
    end

    # @return max_hp [Integer] max hp
    def max_hp
      @max_hp ||= 500
    end

    # @return hp [Integer] current hp
    def hp
      @hp ||= @max_hp
    end

    # @return [Float] xp to next level
    def next_level
      0.8333333333 * (@level - 1) * (2 * @level ^ 2 + 23 * @level + 66)
    end

    # @return [Boolean] can object level up
    def enough_xp?
      @xp > next_level
    end

    # @param amount [Integer] xp amount
    # @return [Boolean] true if object leveled up
    def add_xp(amount)
      @xp += amount
      if enough_xp?
        level_up
        true
      else
        false
      end
    end

    # Levels up the object
    def level_up
      @level += 1
      raise_max_hp
    end

    # Raises max HP of the object
    def raise_max_hp
      @max_hp += 10
      set_hp_to_max
    end

    # Sets objects health back to max
    def set_hp_to_max
      @hp = @max_hp
    end
  end

  # Mixin that allows objects to become angry.
  module Anger
    def anger_level
      @anger_level ||= 0
    end

    # @return angry_since [Object] time
    def angry_since
      @angry_since ||= Time.new '2017'
    end

    # @return [Object] minutes
    def angry_for
      TimeDifference.between(@angry_since, Time.now).in_minutes
    end

    # @return [Boolean] has the object been angry for less than 3 minutes?
    def angry?
      angry_for < 3
    end

    # @param amount [Integer] adds anger
    # @return [Integer] new anger level
    # @return [Object] time
    def add_anger(amount = 1)
      @anger_level += amount unless angry?
      become_angry if anger_level > 50
    end

    # Drops the anger level back down to 0 so the object can start being angry
    # again when it's no longer angry.
    # Sets angry_since to the current time.
    # @return [Object] time
    def become_angry
      @anger_level = 0
      @angry_since = Time.now
    end
  end

  # Mixin to allow objects to be trapped
  module Trap
    # @return trapped_since [Object] time
    def trapped_since
      @trapped_since ||= Time.new '2017'
    end

    # @return [Object] minutes
    def trapped_for
      TimeDifference.between(@trapped_since, Time.now).in_minutes
    end

    # @return [Boolean] has the object been trapped for more than 2 minutes?
    def trap_expired?
      trapped_for > 2
    end

    # @return [Object] time
    def become_trapped
      @trapped_since = Time.now
    end
  end

  # Defines a human player of the game.
  # @param id [Integer] user.id
  # @return [Object] new player object
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
  end

  # Defines a monster and is used to create a new Monster object.
  # an ID will be randomly generated for the new monster.
  # @param data [Hash]
  # @return [Object] new monster object
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
