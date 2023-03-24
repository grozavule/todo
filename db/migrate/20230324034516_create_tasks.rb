class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks, id: :serial do |t|
      t.string :name,  null: false
      t.text :description, null: false
      t.datetime :deadline, null: false
      t.datetime :date_completed
    end
  end
end
