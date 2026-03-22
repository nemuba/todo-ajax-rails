# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastHub::StreamKeyResolver do
  let(:configuration) do
    double(
      'configuration',
      allowed_resources: %w[todo order],
      authorize_scope: authorize_scope,
      stream_key_resolver: stream_key_resolver
    )
  end

  let(:authorize_scope) { ->(context) { context.tenant_id == 't1' } }
  let(:stream_key_resolver) { ->(context) { "tenant:#{context.tenant_id}:#{context.resource_name}:user:#{context.current_user.id}" } }

  before do
    allow(BroadcastHub).to receive(:configuration).and_return(configuration)
  end

  it 'rejects unallowlisted resource with a reason' do
    context = BroadcastHub::StreamKeyContext.new(
      resource_name: 'admin',
      tenant_id: 't1',
      current_user: instance_double('User', id: 1),
      session_id: nil
    )

    expect { described_class.resolve!(context) }
      .to raise_error(BroadcastHub::StreamKeyResolver::Unauthorized, 'invalid_resource')
  end

  it 'rejects missing authorize_scope with a reason' do
    allow(configuration).to receive(:authorize_scope).and_return(nil)
    context = BroadcastHub::StreamKeyContext.new(
      resource_name: 'todo',
      tenant_id: 't1',
      current_user: instance_double('User', id: 1),
      session_id: nil
    )

    expect { described_class.resolve!(context) }
      .to raise_error(BroadcastHub::StreamKeyResolver::Unauthorized, 'missing_authorize_scope')
  end

  it 'rejects unauthorized tenant scope with a reason' do
    context = BroadcastHub::StreamKeyContext.new(
      resource_name: 'todo',
      tenant_id: 'other',
      current_user: instance_double('User', id: 1),
      session_id: nil
    )

    expect { described_class.resolve!(context) }
      .to raise_error(BroadcastHub::StreamKeyResolver::Unauthorized, 'unauthorized_scope')
  end

  it 'rejects missing identity with a reason' do
    allow(configuration).to receive(:stream_key_resolver).and_return(->(_context) { '' })
    context = BroadcastHub::StreamKeyContext.new(
      resource_name: 'todo',
      tenant_id: 't1',
      current_user: nil,
      session_id: nil
    )

    expect { described_class.resolve!(context) }
      .to raise_error(BroadcastHub::StreamKeyResolver::Unauthorized, 'missing_identity')
  end

  it 'returns a stream key when scope is valid' do
    context = BroadcastHub::StreamKeyContext.new(
      resource_name: 'todo',
      tenant_id: 't1',
      current_user: instance_double('User', id: 7),
      session_id: nil
    )

    expect(described_class.resolve!(context)).to eq('tenant:t1:todo:user:7')
  end
end
