class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.string :status
      t.text :code
      t.string :language
      t.integer :grade
      t.integer :work_id
      t.integer :student_id
      t.timestamps
    end
  end
end
