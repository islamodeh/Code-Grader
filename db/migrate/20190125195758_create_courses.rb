class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :section
      t.string :description
      t.integer :instructor_id
      t.timestamps
    end
  end
end
