class AddUuidToCareRelations < ActiveRecord::Migration[7.2]
  def change
    add_column :care_relations, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    add_index :care_relations, :uuid, unique: true

    CareRelation.reset_column_information
    CareRelation.find_each { |rec| rec.update_column(:uuid, SecureRandom.uuid) }
  end
end
