# frozen_string_literal: true

# CreateTodos

# Table: todos
# Columns:
#  id: integer
#  title: string
#  description: string
#  status: integer => default: 0 => Enum: [:pending, :completed]
class CreateTodos < ActiveRecord::Migration[5.2]
  def up
    create_table :todos do |t|
      t.string :title
      t.string :description
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :todos, :title
    add_index :todos, :description
    add_index :todos, :status
  end

  def down
    drop_index :todos, :title
    drop_index :todos, :description
    drop_index :todos, :status

    drop_table :todos
  end
end
