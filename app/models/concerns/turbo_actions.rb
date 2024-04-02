# frozen_string_literal: true

# TurboActions
module TurboActions
  extend ActiveSupport::Concern

  included do
    def turbo_stream_prepend(target)
      broadcast(channel_name, action: 'prepend', target: target, content: partial)
    end

    def turbo_stream_append(target)
      broadcast(channel_name, action: 'append', target: target, content: partial)
    end

    def turbo_stream_replace(target)
      broadcast(channel_name, action: 'update', target: target, content: partial, id: id)
    end

    def turbo_stream_remove(target)
      broadcast(channel_name, action: 'remove', target: target, id: id)
    end

    def turbo_stream_inline(target)
      broadcast(channel_name, action: 'inline', target: target, content: inline,
                              id: id, field: field)
    end
  end
end
