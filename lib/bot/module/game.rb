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

    def initialize(
      xp = 0, level = 0, hr = 0, zenny = 100, max_hp = 500, current_hp = 500,
      time = Time.now
    )
      @xp = xp
      @level = level
      @hr = hr
      @zenny = zenny
      @max_hp = max_hp
      @current_hp = current_hp
      @time = time
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
end
