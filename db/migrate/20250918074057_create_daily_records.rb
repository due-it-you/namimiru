class CreateDailyRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_records do |t|
      t.integer :mood_score, null: false
      t.string :memo, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
