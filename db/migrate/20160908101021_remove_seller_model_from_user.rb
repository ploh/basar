class RemoveSellerModelFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :seller_model, :integer
  end
end
