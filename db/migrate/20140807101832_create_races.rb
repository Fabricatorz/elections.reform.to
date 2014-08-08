class CreateRaces < ActiveRecord::Migration
  def up
    create_table :races do |t|
      t.integer :election_yr, :limit => 2
      t.string :can_id, :limit => 9
      t.boolean :on_ballot
    end

    add_index :races, :election_yr
    add_index :races, :can_id
    add_index :races, [:election_yr, :can_id], :unique => true
  end

  def down
    drop_table :races
  end
end
