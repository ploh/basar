class AddOldSellerCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :old_seller_code, :string
  end
end
