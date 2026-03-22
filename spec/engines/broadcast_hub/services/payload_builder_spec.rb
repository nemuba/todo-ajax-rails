# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastHub::PayloadBuilder do
  it 'requires content for append' do
    expect do
      described_class.build(action: 'append', target: '#todos', content: nil, id: nil, meta: {})
    end.to raise_error(BroadcastHub::PayloadBuilder::ValidationError)
  end

  it 'adds version and keeps allowed keys only' do
    payload = described_class.build(
      action: 'remove',
      target: '#todo_1',
      content: nil,
      id: 'todo_1',
      meta: { request_id: 'x' }
    )

    expect(payload.keys).to contain_exactly(:version, :action, :target, :content, :id, :meta)
    expect(payload[:version]).to eq(1)
  end
end
