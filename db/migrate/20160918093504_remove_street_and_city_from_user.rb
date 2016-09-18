class RemoveStreetAndCityFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :street, :string
    remove_column :users, :city, :string
  end
end
