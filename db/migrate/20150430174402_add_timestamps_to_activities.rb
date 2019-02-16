class AddTimestampsToActivities < ActiveRecord::Migration[4.2]
  def change
    add_timestamps :activities
  end
end
