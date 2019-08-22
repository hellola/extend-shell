class AddTimeDeactivatedToActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :activity, :string
    add_column :activities, :time_deactivated, :datetime
  end
end
