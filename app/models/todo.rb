# frozen_string_literal: true

# Todo
class Todo < ApplicationRecord
  enum status: { pending: 0, completed: 1 }
  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
end
