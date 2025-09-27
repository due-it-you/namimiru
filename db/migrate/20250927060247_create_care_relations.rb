class CreateCareRelations < ActiveRecord::Migration[7.2]
  def change
    create_table :care_relations do |t|
      # 自己結合多対多
      t.references :supported, foreign_key: { to_table: :users }
      t.references :supporter, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
