class RemoveOldSellerCodeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :old_seller_code
  end
end
