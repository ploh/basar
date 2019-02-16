class AddStreetAndCityToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :street, :string
    add_column :users, :city, :string
  end
end
