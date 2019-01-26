class CreateInstructors < ActiveRecord::Migration[5.2]
  def change
    create_table :instructors do |t|
      t.string :full_name
      t.timestamps
    end
  end
end
