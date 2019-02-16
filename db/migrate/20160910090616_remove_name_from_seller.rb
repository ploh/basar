class RemoveNameFromSeller < ActiveRecord::Migration[4.2]
  def change
    remove_column :sellers, :name, :string
  end
end
