class AddLogEntryReference < ActiveRecord::Migration[7.1]
  def change
    add_reference :log_entries, :user, foreign_key: true
  end
end
