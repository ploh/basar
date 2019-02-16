class RemoveRateFromSeller < ActiveRecord::Migration[4.2]
  def change
    remove_column :sellers, :rate, :decimal
  end
end
