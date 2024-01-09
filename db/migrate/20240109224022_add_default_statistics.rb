class AddDefaultStatistics < ActiveRecord::Migration[7.1]
  def change
    change_column_default :statistics, :xp, from: nil, to: 0
    change_column_default :statistics, :level, from: nil, to: 1
    change_column_default :statistics, :time_active, from: nil, to: 0
    change_column_default :statistics, :streak, from: nil, to: 0
  end
end
