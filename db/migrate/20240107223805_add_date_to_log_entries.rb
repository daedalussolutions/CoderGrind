class AddDateToLogEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :log_entries, :date, :date
  end
end
