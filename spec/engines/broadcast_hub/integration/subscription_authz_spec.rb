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

  before do
    BroadcastHub.configure do |config|
      config.allowed_resources = ['todo']
      config.authorize_scope = lambda do |context|
        context.current_user&.id == 9 && context.tenant_id == 'tenant-9'
      end
      config.stream_key_resolver = lambda do |context|
        "tenant:#{context.tenant_id}:#{context.resource_name}:user:#{context.current_user.id}"
      end
    end

    stub_connection current_user: instance_double('User', id: 9)
  end

  it 'rejects subscription when resource is missing' do
    subscribe(resource: nil, tenant: 'tenant-9')

    expect(subscription).to be_rejected
  end

  it 'rejects subscription when tenant scope is unauthorized' do
    subscribe(resource: 'todo', tenant: 'tenant-other')

    expect(subscription).to be_rejected
  end
end
