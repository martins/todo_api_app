class CreateTagsTask < ActiveRecord::Migration[5.2]
  def change
    create_table :tags_tasks do |t|
      t.references :tag, foreign_key: true, null: false
      t.references :task, foreign_key: true, null: false
    end
  end
end
