class RenameSellersTasksToActivities < ActiveRecord::Migration
  def change
    rename_table :sellers_tasks, :activities
  end
end
