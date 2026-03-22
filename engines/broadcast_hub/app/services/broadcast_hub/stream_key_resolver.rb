# frozen_string_literal: true

module BroadcastHub
  class StreamKeyResolver
    class Unauthorized < StandardError; end

    class << self
      def resolve!(context)
        reject!('missing_resource') if context.resource_name.to_s.strip.empty?

        allowed_resources = Array(configuration.allowed_resources).map(&:to_s)
        reject!('invalid_resource') unless allowed_resources.include?(context.resource_name.to_s)

        authorize_scope = configuration.authorize_scope
        reject!('missing_authorize_scope') unless authorize_scope.respond_to?(:call)
        reject!('unauthorized_scope') unless authorize_scope.call(context)

        stream_key_resolver = configuration.stream_key_resolver
        reject!('missing_stream_key_resolver') unless stream_key_resolver.respond_to?(:call)

        stream_key = stream_key_resolver.call(context)
        reject!('missing_identity') if stream_key.to_s.strip.empty?

        stream_key
      end

      private

      def configuration
        BroadcastHub.configuration
      end

      def reject!(reason)
        raise Unauthorized, reason
      end
    end
  end
end
