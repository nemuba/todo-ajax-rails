module BroadcastHub
  class Configuration
    attr_accessor :payload_version, :update_strategy, :strict_client_validation, :stream_key_resolver

    def initialize
      @payload_version = 1
      @update_strategy = :replace_with
      @strict_client_validation = false
      @stream_key_resolver = nil
    end
  end
end
