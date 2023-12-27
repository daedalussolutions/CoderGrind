class CreateStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :statistics do |t|
      t.integer :xp
      t.integer :level
      t.integer :time_active
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
