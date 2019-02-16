class AddOldSellerCodeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :old_seller_code, :string
  end
end
