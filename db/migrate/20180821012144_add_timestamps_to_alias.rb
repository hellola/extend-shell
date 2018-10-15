class AddTimestampsToAlias < ActiveRecord::Migration[5.1]
  def change
    add_column :aliases, :created_at, :datetime
    add_column :aliases, :updated_at, :datetime
  end
end
