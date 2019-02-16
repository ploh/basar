class AddModelToSeller < ActiveRecord::Migration[4.2]
  def change
    add_column :sellers, :model, :integer
  end
end
