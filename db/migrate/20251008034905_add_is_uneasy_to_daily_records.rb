class AddIsUneasyToDailyRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_records, :is_uneasy, :boolean, default: false, null: false
  end
end
