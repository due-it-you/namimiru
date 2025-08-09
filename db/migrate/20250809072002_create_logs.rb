class CreateLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :logs do |t|
      t.integer :mood_score, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
