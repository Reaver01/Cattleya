Sequel.migration do
  up do
    create_table(:active_monsters) do
      primary_key :id
      foreign_key :monster_id, :monsters
      Integer :channel
      Integer :hp_left, default: 0
      DateTime :trapped_since, default: Time.new('2017')
      DateTime :angry_since, default: Time.new('2017')
      Integer :anger_level, default: 0
    end
  end

  down do
    drop_table(:active_monsters)
  end
end
