class AddWeightingToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :weighting, :float
  end
end
