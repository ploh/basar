class AddStreetAndCityToUser < ActiveRecord::Migration
  def change
    add_column :users, :street, :string
    add_column :users, :city, :string
  end
end
