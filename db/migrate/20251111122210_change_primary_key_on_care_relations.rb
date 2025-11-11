class ChangePrimaryKeyOnCareRelations < ActiveRecord::Migration[7.2]
  def change
    execute 'ALTER TABLE care_relations DROP CONSTRAINT care_relations_pkey;'
    execute 'ALTER TABLE care_relations ADD PRIMARY KEY (uuid);'
  end
end
