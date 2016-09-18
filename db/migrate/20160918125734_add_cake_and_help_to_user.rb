class AddCakeAndHelpToUser < ActiveRecord::Migration
  def change
    add_column :users, :cake, :boolean
    add_column :users, :help, :boolean
  end
end
