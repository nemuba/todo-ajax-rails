# frozen_string_literal: true

module Broadcaster
  extend ActiveSupport::Concern
  include TurboStream

  class_methods do
    def broadcast_to(target)
      after_create_commit { turbo_stream_append(target) }
      after_update_commit { turbo_stream_replace(target) }
      after_destroy_commit { turbo_stream_remove(target) }
    end
  end
end
