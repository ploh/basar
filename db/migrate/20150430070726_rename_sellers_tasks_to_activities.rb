class RenameSellersTasksToActivities < ActiveRecord::Migration[4.2]
  def change
    rename_table :sellers_tasks, :activities
  end
end
