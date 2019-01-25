class CreateSamples < ActiveRecord::Migration[5.2]
  def change
    create_table :samples do |t|
      t.integer :work_id
      t.string :input
      t.string :output
      t.timestamps
    end
  end
end
