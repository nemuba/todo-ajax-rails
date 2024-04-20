# frozen_string_literal: true

# TodoChannel
class TodoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "todo_channel_#{current_user.id}"
  end

  def append(args)
    todo = Todo.find(args['id'])
    todo.turbo_stream_append(args['target'])
  end

  def prepend(args)
    todo = Todo.find(args['id'])
    todo.turbo_stream_prepend(args['target'])
  end

  def update(args)
    todo = Todo.find(args['id'])
    todo.turbo_stream_replace(args['target'])
  end
end
