class AddPolymorphicForSubmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :student_id
    add_column :submissions, :userable_id, :integer
    add_column :submissions, :userable_type, :string
  end
end
