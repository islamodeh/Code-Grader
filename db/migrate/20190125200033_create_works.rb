class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.integer :course_id
      t.string :work_type
      t.string :description
      t.timestamps
    end
  end
end
