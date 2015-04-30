class Activity < ActiveRecord::Base
  belongs_to :seller
  belongs_to :task

  def task_description
    task && task.description
  end
end
