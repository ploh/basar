class RemoveOldSellerCodeFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :old_seller_code
  end
end
