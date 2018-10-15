class AddTimestampsToFunction < ActiveRecord::Migration[5.1]
  def change
    add_column :functions, :created_at, :datetime
    add_column :functions, :updated_at, :datetime
  end
end
