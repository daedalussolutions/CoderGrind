class AddStreakToStatistic < ActiveRecord::Migration[7.1]
  def change
    add_column :statistics, :streak, :int
  end
end
