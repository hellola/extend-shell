class RenameStartupCommandToExecutableId < ActiveRecord::Migration[5.1]
  def change
    rename_column :startups, :command, :executable_id
  end
end
