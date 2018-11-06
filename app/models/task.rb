class Task < ApplicationRecord
  has_many :tags_tasks
  has_many :tags, through: :tags_tasks

  validates :title, presence: true
end
