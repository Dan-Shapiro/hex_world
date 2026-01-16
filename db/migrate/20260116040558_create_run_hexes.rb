class CreateRunHexes < ActiveRecord::Migration[8.0]
  def change
    create_table :run_hexes do |t|
      t.references :run, null: false, foreign_key: true
      t.references :hex, null: false, foreign_key: true
      t.integer :unlocked_at_turn, null: false

      t.timestamps
    end

    add_index :run_hexes, [ :run_id, :hex_id ], unique: true
    add_index :run_hexes, :unlocked_at_turn
  end
end
