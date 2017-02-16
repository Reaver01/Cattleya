Sequel.migration do
  up do
    create_table(:players) do
      primary_key :id
      Integer :discord_id
      Integer :hr, default: 0
      Integer :level, default: 0
      Integer :xp, default: 0
      Integer :max_hp, default: 500
      Integer :hp, default: 500
      Integer :zenny, default: 100
      DateTime :last_xp_gain, default: Time.now
      DateTime :death_time, default: Time.new('2017')
      TrueClass :notifications, default: false
    end
  end

  down do
    drop_table(:players)
  end
end
