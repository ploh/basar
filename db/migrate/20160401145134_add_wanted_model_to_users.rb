class AddWantedModelToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :seller_model, :integer
  end
end
