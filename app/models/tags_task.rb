class TagsTask < ApplicationRecord
  belongs_to :task
  belongs_to :tag

  validates :task_id, uniqueness: { scope: :tag_id }
end
