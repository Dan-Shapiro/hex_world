class CreateRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :runs do |t|
      t.jsonb :state, null: false, default: {}
      t.integer :turn, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.integer :seed, null: false

      t.timestamps
    end

    add_index :runs, :status
  end
end
