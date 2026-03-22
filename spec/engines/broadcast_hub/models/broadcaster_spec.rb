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

  let(:test_todo_with_user_class) do
    stub_const('TestTodoWithUser', Class.new(ApplicationRecord) do
      self.table_name = 'todos'

      belongs_to :user, optional: true

      include BroadcastHub::Broadcaster
      broadcast_to :todo, partial: 'todos/todo', target: '#todos'
    end)
  end

  let(:test_todo_with_custom_context_class) do
    stub_const('TestTodoWithCustomContext', Class.new(ApplicationRecord) do
      self.table_name = 'todos'

      include BroadcastHub::Broadcaster
      broadcast_to :todo, partial: 'todos/todo', target: '#todos'

      private

      def broadcast_hub_stream_key_context_attributes
        {
          tenant_id: 'tenant-9',
          current_user: Struct.new(:id).new(99),
          session_id: 'session-abc',
          params: { source: 'spec' }
        }
      end
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

  it 'does not infer current_user from model association by default' do
    captured_context = nil
    BroadcastHub.configure do |config|
      config.stream_key_resolver = lambda do |context|
        captured_context = context
        'tenant:t1:todo'
      end
    end

    renderer = instance_double(BroadcastHub::Renderer, render: "<li id='todo_1'>A</li>")
    allow(BroadcastHub::Renderer).to receive(:new).and_return(renderer)

    user = create(:user)
    todo = test_todo_with_user_class.new(id: 1, title: 'A', user: user)

    allow(ActionCable.server).to receive(:broadcast)

    todo.broadcast_append('#todos')

    expect(captured_context.current_user).to be_nil
  end

  it 'allows overriding stream key context attributes in the model' do
    captured_context = nil
    BroadcastHub.configure do |config|
      config.stream_key_resolver = lambda do |context|
        captured_context = context
        'tenant:t1:todo'
      end
    end

    renderer = instance_double(BroadcastHub::Renderer, render: "<li id='todo_1'>A</li>")
    allow(BroadcastHub::Renderer).to receive(:new).and_return(renderer)

    todo = test_todo_with_custom_context_class.new(id: 1, title: 'A')

    allow(ActionCable.server).to receive(:broadcast)

    todo.broadcast_append('#todos')

    expect(captured_context.tenant_id).to eq('tenant-9')
    expect(captured_context.current_user.id).to eq(99)
    expect(captured_context.session_id).to eq('session-abc')
    expect(captured_context.params).to eq({ source: 'spec' })
  end
end
