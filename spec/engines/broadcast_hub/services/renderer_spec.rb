# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastHub::Renderer do
  it 'renders configured partial with locals' do
    fake_renderer = double('Renderer', render: "<li id='todo_1'>A</li>")
    renderer = described_class.new(renderer: fake_renderer)

    html = renderer.render(partial: 'todos/todo', locals: { todo: double(id: 1) })

    expect(html).to eq("<li id='todo_1'>A</li>")
  end
end
