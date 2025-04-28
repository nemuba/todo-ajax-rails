# frozen_string_literal: true

class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :created_at, :updated_at

  belongs_to :user
end
