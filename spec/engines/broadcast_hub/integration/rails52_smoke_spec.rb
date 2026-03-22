# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BroadcastHub Rails 5.2 smoke', type: :model do
  let(:smoke_todo_class) do
    stub_const('Rails52SmokeTodo', Class.new(ApplicationRecord) do
      self.table_name = 'todos'

      include BroadcastHub::Broadcaster
      broadcast_to :todo, partial: 'todos/todo', target: '#todos'
    end)
  end

  around do |example|
    original_configuration = BroadcastHub.configuration
    BroadcastHub.configuration = BroadcastHub::Configuration.new
    hide_const('Turbo') if Object.const_defined?(:Turbo)
    example.run
  ensure
    BroadcastHub.configuration = original_configuration
  end

  it 'broadcasts append, update, and remove payloads without Turbo runtime constants' do
    BroadcastHub.configure do |config|
      config.allowed_resources = ['todo']
      config.authorize_scope = ->(_context) { true }
      config.stream_key_resolver = ->(_context) { 'tenant:t1:todo:user:7' }
    end

    renderer = instance_double(BroadcastHub::Renderer, render: "<li id='todo_1'>A</li>")
    allow(BroadcastHub::Renderer).to receive(:new).and_return(renderer)
    allow(ActionCable.server).to receive(:broadcast)

    todo = smoke_todo_class.create!(title: 'A', description: 'Desc', status: :pending)
    todo.update!(title: 'A+')
    todo.destroy!

    expect(ActionCable.server).to have_received(:broadcast).with(
      'tenant:t1:todo:user:7',
      hash_including(
        version: 1,
        action: 'append',
        target: '#todos',
        id: "rails52_smoke_todo_#{todo.id}",
        content: "<li id='todo_1'>A</li>",
        meta: {}
      )
    )
    expect(ActionCable.server).to have_received(:broadcast).with(
      'tenant:t1:todo:user:7',
      hash_including(
        version: 1,
        action: 'update',
        target: '#todos',
        id: "rails52_smoke_todo_#{todo.id}",
        content: "<li id='todo_1'>A</li>",
        meta: {}
      )
    )
    expect(ActionCable.server).to have_received(:broadcast).with(
      'tenant:t1:todo:user:7',
      hash_including(
        version: 1,
        action: 'remove',
        target: '#todos',
        id: "rails52_smoke_todo_#{todo.id}",
        content: nil,
        meta: {}
      )
    )
  end
end
