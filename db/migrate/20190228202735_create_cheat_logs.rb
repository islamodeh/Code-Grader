class CreateCheatLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :cheat_logs do |t|
      t.integer :submission_id
      t.integer :cheated_from_submission_id
      t.integer :cheat_percentage
      t.timestamps
    end
  end
end
