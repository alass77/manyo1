class RenameDateFieldInTasks < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :date_field, :deadline_on
  end
end
