# frozen_string_literal: true

# Todo
class Todo < ApplicationRecord
  include Broadcaster

  belongs_to :user

  attribute :field, :string
  attribute :inline_editing, :boolean

  enum status: { pending: 0, completed: 1 }
  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  broadcast_to :todos

  scope :search, ->(column, term) { where("#{column} ILIKE ?", "%#{term}%") }
  scope :order_by, ->(column, direction) { order("#{column} #{direction}") }
end
