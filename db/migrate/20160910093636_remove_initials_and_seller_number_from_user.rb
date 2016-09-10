class RemoveInitialsAndSellerNumberFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :initials, :string
    remove_column :users, :seller_number, :integer
  end
end
