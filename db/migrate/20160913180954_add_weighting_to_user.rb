class AddWeightingToUser < ActiveRecord::Migration
  def change
    add_column :users, :weighting, :float
  end
end
