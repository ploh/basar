class AddCakeAndHelpToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :cake, :boolean
    add_column :users, :help, :boolean
  end
end
