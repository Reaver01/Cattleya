module Game
  # Inventory module
  module Inventory
    def inventory
      @inventory ||= []
    end

    def item(id)
      @inventory[id] || 0
    end

    def add_item(id)
      @inventory[id] = item(id) + 1
    end

    def remove_item(id)
      @inventory[id] = if item(id) <= 1
                         0
                       else
                         item(id) - 1
                       end
    end

    def set_item(id, quantity)
      @inventory[id] = quantity
    end
  end

  # Defines the player
  class Player
    include Inventory

    attr_reader :xp

    attr_reader :level

    attr_reader :hr

    attr_reader :zenny

    attr_reader :max_hp

    attr_reader :current_hp

    attr_reader :time

    attr_reader :inventory

    def initialize
      @xp = 0
      @level = 0
      @hr = 0
      @zenny = 100
      @max_hp = 500
      @current_hp = 500
      @time = Time.now
    end

    def self.from_json(data)
      new(
        xp: data['xp'],
        level: data['level'],
        hr: data['hr'],
        zenny: data['zenny'],
        max_hp: data['max_hp'],
        current_hp: data['current_hp'],
        time: data['time'],
        inventory: data['inventory']
      )
    end
  end

  # Hitpoints module
  module Hitpoints
    # Defines attacking
    class Attack
      attr_reader :id

      attr_reader :damage

      def initialize(id, damage = 1)
        @id = id
        @damage = damage
      end
    end

    def hp(set = nil)
      return @hp ||= 1 unless set
      @hp = set
    end

    def dead?
      @hp <= 0
    end

    def alive?
      @hp > 0
    end

    def attacks_by(id = nil)
      return @attacks_by ||= [] unless id
      @attacks_by.select { |a| a.id == id }
    end

    def damage_from(id)
      attacks_by(id).map(&:damage).reduce(:+)
    end

    def attacked_ids
      @attacks_by.map(&:id)
    end

    def attacked_by?(id)
      attacked_ids.include? id
    end

    def attacked(id, damage)
      @attacks_by << Attack.new(id, damage)
      @hp -= damage
    end
  end

  # Defines a monster
  class Monster
    include Hitpoints

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
