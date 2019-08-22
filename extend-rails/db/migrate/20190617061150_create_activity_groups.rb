class CreateActivityGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :activity_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
