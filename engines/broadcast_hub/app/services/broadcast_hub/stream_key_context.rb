# frozen_string_literal: true

module BroadcastHub
  class StreamKeyContext
    attr_reader :resource_name, :tenant_id, :current_user, :session_id, :params

    def initialize(resource_name:, tenant_id:, current_user:, session_id:, params: {})
      @resource_name = resource_name
      @tenant_id = tenant_id
      @current_user = current_user
      @session_id = session_id
      @params = (params || {}).dup.freeze
      freeze
    end
  end
end
