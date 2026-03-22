# frozen_string_literal: true

BroadcastHub.configure do |config|
  config.allowed_resources = %w[todo]

  config.authorize_scope = lambda do |context|
    context.current_user.present?
  end

  config.stream_key_resolver = lambda do |context|
    "resource:#{context.resource_name}:user:#{context.current_user.id}"
  end
end
