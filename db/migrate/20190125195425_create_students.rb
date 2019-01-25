class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :email
      t.string :full_name
      t.string :password_digest
      t.timestamps
    end
  end
end
