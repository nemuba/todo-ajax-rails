# frozen_string_literal: true

# TodoChannel
class TodoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "todo_channel_#{current_user.id}"
  end
end
