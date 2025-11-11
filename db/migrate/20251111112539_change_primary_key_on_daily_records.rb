class ChangePrimaryKeyOnDailyRecords < ActiveRecord::Migration[7.2]
  def change
    execute 'ALTER TABLE daily_records DROP CONSTRAINT daily_records_pkey;'
    execute 'ALTER TABLE daily_records ADD PRIMARY KEY (uuid);'
  end
end
