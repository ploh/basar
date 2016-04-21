class Activity < ActiveRecord::Base
  belongs_to :seller, touch: true
  belongs_to :task

  validates :planned_count, inclusion: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  def task_description
    task && task.description
  end

  def me
    planned_count > 0.99
  end

  def helper
    planned_count > 1.99
  end
end
