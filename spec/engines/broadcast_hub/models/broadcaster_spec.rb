# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BroadcastHub::Broadcaster' do
  let(:test_todo_class) do
    stub_const('TestTodo', Class.new(ApplicationRecord) do
      self.table_name = 'todos'

      include BroadcastHub::Broadcaster
      broadcast_to :todo, partial: 'todos/todo', target: '#todos'
    end)
  end

  after do
    BroadcastHub.configuration.stream_key_resolver = nil
  end

  it 'registers lifecycle callbacks through broadcast_to' do
    expect(test_todo_class).to respond_to(:broadcast_to)
  end

  it 'defines broadcast lifecycle methods' do
    todo = test_todo_class.new(id: 1, title: 'A')

    expect(todo).to respond_to(:broadcast_append)
    expect(todo).to respond_to(:broadcast_update)
    expect(todo).to respond_to(:broadcast_remove)
  end

  it 'broadcasts append using configured stream key resolver context' do
    captured_context = nil
    BroadcastHub.configure do |config|
      config.stream_key_resolver = lambda do |context|
        captured_context = context
        'tenant:t1:todo:user:1'
      end
    end

    renderer = instance_double(BroadcastHub::Renderer, render: "<li id='todo_1'>A</li>")
    allow(BroadcastHub::Renderer).to receive(:new).and_return(renderer)

    todo = test_todo_class.new(id: 1, title: 'A')

    expect(ActionCable.server).to receive(:broadcast).with(
      'tenant:t1:todo:user:1',
      hash_including(action: 'append', target: '#todos', content: "<li id='todo_1'>A</li>")
    )

    todo.broadcast_append('#todos')

    expect(captured_context).to be_a(BroadcastHub::StreamKeyContext)
    expect(captured_context.resource_name).to eq('todo')
  end
end
