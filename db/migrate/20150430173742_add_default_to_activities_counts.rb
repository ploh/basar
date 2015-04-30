class AddDefaultToActivitiesCounts < ActiveRecord::Migration
  def change
    change_column_default :activities, :actual_count, 0
    change_column_default :activities, :planned_count, 0

    Activity.all.each do |activity|
      unless activity.actual_count && activity.planned_count
        activity.actual_count = 0 unless activity.actual_count
        activity.planned_count = 0 unless activity.planned_count
        activity.save
      end
    end
    change_column_null :activities, :actual_count, false
    change_column_null :activities, :planned_count, false
  end
end
