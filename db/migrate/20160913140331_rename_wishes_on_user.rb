class RenameWishesOnUser < ActiveRecord::Migration
  def change
    rename_column :users, :wishA, :wish_a
    rename_column :users, :wishB, :wish_b
    rename_column :users, :wishC, :wish_c
  end
end
