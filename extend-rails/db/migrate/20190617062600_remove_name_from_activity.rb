class RemoveNameFromActivity < ActiveRecord::Migration[5.1]
  def change
    remove_column :activities, :name, :string
  end
end
