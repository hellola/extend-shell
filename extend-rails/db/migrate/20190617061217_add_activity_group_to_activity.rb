class AddActivityGroupToActivity < ActiveRecord::Migration[5.1]
  def change
    add_reference :activities, :activity_group, foreign_key: true
  end
end
