class RenameLabelTasksToLabelsTasks < ActiveRecord::Migration[6.0]
  def change
    rename_table :label_tasks, :labels_tasks
  end
end
