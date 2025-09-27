class AddUniqueToSupportedIdAndSupporterId < ActiveRecord::Migration[7.2]
  def change
  end
  add_index :care_relations, [:supported_id, :supporter_id], unique: true
end
