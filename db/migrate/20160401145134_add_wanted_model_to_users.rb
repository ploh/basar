class AddWantedModelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seller_model, :integer
  end
end
