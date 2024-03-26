# frozen_string_literal: true

# Todo
class Todo < ApplicationRecord
  include TurboStream

  belongs_to :user

  attribute :field, :string

  enum status: { pending: 0, completed: 1 }
  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  after_create_commit { turbo_stream_append('#todos') }
  after_update_commit { turbo_stream_replace('#todos') }
  after_destroy_commit { turbo_stream_remove('#todos') }
end
