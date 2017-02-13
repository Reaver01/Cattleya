module Game
  # Defines the player
  class Player
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
      time = Time.now, inventory = Inventory.new
    )
      @xp = xp
      @level = level
      @hr = hr
      @zenny = zenny
      @max_hp = max_hp
      @current_hp = current_hp
      @time = time
      @inventory = inventory
    end
  end

  # Defines the inventory
  class Inventory
    attr_reader :contents

    def initialize
      @contents = { '0' => 1 }
    end

    def add(item)
      if @contents.key?(item.to_s)
        @contents[item.to_s] += 1
      else
        @contents[item.to_s] = 1
      end
    end

    def remove(item)
      if @contents.key?(item.to_s)
        @contents[item.to_s] -= 1 unless @contents[item.to_s].zero?
      end
    end
  end
end
