class AddModelToSeller < ActiveRecord::Migration
  def change
    add_column :sellers, :model, :integer
  end
end
