class AddTimestampsToActivities < ActiveRecord::Migration
  def change
    add_timestamps :activities
  end
end
