class AddOrderToStartup < ActiveRecord::Migration[5.1]
  def change
    add_column :startups, :order, :integer
  end
end
