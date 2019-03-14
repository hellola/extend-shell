class AddFullNameToHotkey < ActiveRecord::Migration[5.1]
  def change
    add_column :hotkeys, :full_name, :string
  end
end
