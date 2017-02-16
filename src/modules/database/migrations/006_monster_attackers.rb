Sequel.migration do
  up do
    create_table(:monster_attackers) do
      primary_key :id
      foreign_key :active_monster_id, :active_monsters
      foreign_key :player_id, :players
      Integer :damage_done, default: 0
    end
  end

  down do
    drop_table(:monster_attackers)
  end
end
