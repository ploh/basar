class RemoveRateFromSeller < ActiveRecord::Migration
  def change
    remove_column :sellers, :rate, :decimal
  end
end
