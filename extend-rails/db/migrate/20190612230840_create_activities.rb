class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :host
      t.string :application
      t.string :title
      t.datetime :time_activated

      t.timestamps
    end
  end
end
