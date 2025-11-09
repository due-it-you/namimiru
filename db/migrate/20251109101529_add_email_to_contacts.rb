class AddEmailToContacts < ActiveRecord::Migration[7.2]
  def change
  end

  add_column :contacts, :email, :string
end
