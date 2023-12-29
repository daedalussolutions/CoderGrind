class AlterLogEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :log_entries, :title, :string
    add_column :log_entries, :project, :string
    add_column :log_entries, :time, :integer
    add_column :log_entries, :lines, :integer
    add_column :log_entries, :characters, :integer
    add_column :log_entries, :language, :string
    add_column :log_entries, :framework, :string
    add_column :log_entries, :contributions, :string
  end
end