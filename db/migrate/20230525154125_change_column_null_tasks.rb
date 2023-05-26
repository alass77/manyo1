class ChangeColumnNullTasks < ActiveRecord::Migration[6.0]
  change_column :tasks, :title, :string, null: false
end