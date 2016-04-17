class AddSellerNumberAndInitialsToUser < ActiveRecord::Migration
  def change
    add_column :users, :seller_number, :integer
    add_index :users, :seller_number
    add_column :users, :initials, :string
  end
end
