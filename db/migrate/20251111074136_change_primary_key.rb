class ChangePrimaryKey < ActiveRecord::Migration[7.2]
  def change
    execute 'ALTER TABLE users DROP CONSTRAINT users_pkey;'
    execute 'ALTER TABLE users ADD PRIMARY KEY (uuid);'
  end
end
