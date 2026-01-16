class CreateHexes < ActiveRecord::Migration[8.0]
  def change
    create_table :hexes do |t|
      t.integer :q, null: false
      t.integer :r, null: false
      t.string :spell_key, null: false
      t.jsonb :data, null: false, default: {}

      t.timestamps
    end

    add_index :hexes, [ :q, :r ], unique: true
    add_index :hexes, :spell_key, unique: true
  end
end
