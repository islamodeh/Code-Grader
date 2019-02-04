class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.integer :course_id
      t.string :name
      t.string :work_type
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
