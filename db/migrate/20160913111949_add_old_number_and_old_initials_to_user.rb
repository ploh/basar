class AddOldNumberAndOldInitialsToUser < ActiveRecord::Migration
  def change
    add_column :users, :old_number, :integer
    add_column :users, :old_initials, :string
  end
end
