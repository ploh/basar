class RemoveNameFromSeller < ActiveRecord::Migration
  def change
    remove_column :sellers, :name, :string
  end
end
