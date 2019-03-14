class AddTimestampsToHotkey < ActiveRecord::Migration[5.1]
  def change
    add_column :hotkeys, :created_at, :datetime
    add_column :hotkeys, :updated_at, :datetime
  end
end
