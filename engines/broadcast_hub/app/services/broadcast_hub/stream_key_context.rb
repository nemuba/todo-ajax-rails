# frozen_string_literal: true

module BroadcastHub
  class StreamKeyContext
    attr_reader :resource_name, :tenant_id, :current_user, :session_id, :params

    def self.from_connection(connection:, params: {})
      normalized_params = normalize_params(params)

      new(
        resource_name: normalized_params[:resource],
        tenant_id: normalized_params[:tenant],
        current_user: connection_value(connection, :current_user),
        session_id: connection_value(connection, :session_id) || normalized_params[:session_id],
        params: normalized_params
      )
    end

    def initialize(resource_name:, tenant_id:, current_user:, session_id:, params: {})
      @resource_name = resource_name
      @tenant_id = tenant_id
      @current_user = current_user
      @session_id = session_id
      @params = (params || {}).dup.freeze
      freeze
    end

    class << self
      private

      def normalize_params(params)
        hash = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params.to_h
        hash.symbolize_keys
      rescue StandardError
        {}
      end

      def connection_value(connection, key)
        return nil unless connection.respond_to?(key)

        connection.public_send(key)
      end
    end
  end
end
