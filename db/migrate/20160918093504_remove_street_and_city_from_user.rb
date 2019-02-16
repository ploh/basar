class RemoveStreetAndCityFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :street, :string
    remove_column :users, :city, :string
  end
end
