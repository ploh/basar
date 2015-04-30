class ChangeActivityCountsToFloat < ActiveRecord::Migration
  def up
    change_column :activities, :actual_count, :float
    change_column :activities, :planned_count, :float
  end

  def down
    change_column :activities, :actual_count, :integer
    change_column :activities, :planned_count, :integer
  end
end
