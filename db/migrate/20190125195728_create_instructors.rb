class CreateInstructors < ActiveRecord::Migration[5.2]
  def change
    create_table :instructors do |t|
      t.string :email
      t.string :full_name
      t.string :password_digest
      t.timestamps
    end
  end
end
