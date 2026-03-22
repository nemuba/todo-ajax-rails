# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastHub::StreamChannel, type: :channel do
  around do |example|
    original_configuration = BroadcastHub.configuration
    BroadcastHub.configuration = BroadcastHub::Configuration.new
    example.run
  ensure
    BroadcastHub.configuration = original_configuration
  end

  it 'resolves stream using current_user auth mode' do
    captured_context = nil
    BroadcastHub.configure do |config|
      config.allowed_resources = ['todo']
      config.authorize_scope = ->(context) { context.tenant_id == 't1' && context.current_user&.id == 42 }
      config.stream_key_resolver = lambda do |context|
        captured_context = context
        "tenant:#{context.tenant_id}:#{context.resource_name}:user:#{context.current_user.id}"
      end
    end

    stub_connection current_user: instance_double('User', id: 42)

    subscribe(resource: 'todo', tenant: 't1')

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('tenant:t1:todo:user:42')
    expect(captured_context.current_user.id).to eq(42)
    expect(captured_context.session_id).to be_nil
  end

  it 'supports no-auth mode via session resolver path' do
    captured_context = nil
    BroadcastHub.configure do |config|
      config.allowed_resources = ['todo']
      config.authorize_scope = ->(context) { context.tenant_id == 'public' && context.session_id == 'sess-22' }
      config.stream_key_resolver = lambda do |context|
        captured_context = context
        "tenant:#{context.tenant_id}:#{context.resource_name}:session:#{context.session_id}"
      end
    end

    stub_connection current_user: nil, session_id: 'sess-22'

    subscribe(resource: 'todo', tenant: 'public')

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('tenant:public:todo:session:sess-22')
    expect(captured_context.current_user).to be_nil
    expect(captured_context.session_id).to eq('sess-22')
  end
end
