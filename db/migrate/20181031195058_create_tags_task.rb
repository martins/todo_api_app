class CreateTagsTask < ActiveRecord::Migration[5.2]
  def change
    create_table :tags_tasks do |t|
      t.references :task, foreign_key: true, null: false, index: false
      t.references :tag, foreign_key: true, null: false, index: false
    end

    add_index :tags_tasks, [:task_id, :tag_id], unique: true
  end
end
