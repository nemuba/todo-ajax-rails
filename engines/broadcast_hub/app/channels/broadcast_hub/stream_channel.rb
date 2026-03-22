# frozen_string_literal: true

module BroadcastHub
  class StreamChannel < ApplicationCable::Channel
    def subscribed
      stream_from(BroadcastHub::StreamKeyResolver.resolve!(stream_key_context))
    rescue BroadcastHub::StreamKeyResolver::Unauthorized => e
      logger.info("broadcast_hub.reject reason=#{e.message}") if defined?(Rails) && Rails.env.development?
      reject
    end

    private

    def stream_key_context
      BroadcastHub::StreamKeyContext.from_connection(connection: connection, params: params)
    end
  end
end
