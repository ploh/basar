class RemoveInitialsAndSellerNumberFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :initials, :string
    remove_column :users, :seller_number, :integer
  end
end
