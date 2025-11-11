class AddUuidColumnToDailyRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_records, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :daily_records, :uuid, unique: true

    DailyRecord.reset_column_information
    DailyRecord.find_each { |record| record.update_column(:uuid, SecureRandom.uuid) }
  end
end
