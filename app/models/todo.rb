# frozen_string_literal: true

# Todo
class Todo < ApplicationRecord
  include BroadcastHub::Broadcaster

  belongs_to :user

  attribute :field, :string
  attribute :inline_editing, :boolean

  enum status: { pending: 0, completed: 1 }
  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  broadcast_to :todo, partial: 'todos/partials/todo', target: '#todos'

  scope :search, ->(column, term) { where("#{column} ILIKE ?", "%#{term}%") }
  scope :order_by, ->(column, direction) { order("#{column} #{direction}") }

  # Legacy ActionCable channel compatibility during BroadcastHub migration.
  def turbo_stream_append(target)
    broadcast_append(target)
  end

  def turbo_stream_prepend(target)
    broadcast_prepend(target)
  end

  def turbo_stream_replace(target)
    broadcast_update(target)
  end

  def turbo_stream_remove(target)
    broadcast_remove(target)
  end

  private

  def broadcast_hub_stream_key_context_attributes
    {
      tenant_id: nil,
      current_user: user,
      session_id: nil,
      params: {}
    }
  end
end
