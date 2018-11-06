class Tag < ApplicationRecord
  has_many :tags_tasks
  has_many :tasks, through: :tags_tasks

  validates :title, presence: true, uniqueness: true
end
