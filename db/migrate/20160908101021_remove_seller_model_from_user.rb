class RemoveSellerModelFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :seller_model, :integer
  end
end
