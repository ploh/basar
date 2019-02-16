class AddModelWishesToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :wishA, :integer
    add_column :users, :wishB, :integer
    add_column :users, :wishC, :integer
  end
end
