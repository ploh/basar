class Activity < ActiveRecord::Base
  belongs_to :seller, touch: true
  belongs_to :task

  validates :planned_count, inclusion: (0..12).to_a
  validates :actual_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

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
