# frozen_string_literal: true

# TurboActions
module TurboActions
  extend ActiveSupport::Concern

  included do
    def turbo_stream_append(target)
      ActionCable.server.broadcast(channel_name, action: 'append', target: target, content: append)
    end

    def turbo_stream_replace(target)
      ActionCable.server.broadcast(channel_name, action: 'update', target: target, content: replace, id: id)
    end

    def turbo_stream_remove(target)
      ActionCable.server.broadcast(channel_name, action: 'remove', target: target, id: id)
    end

    def turbo_stream_inline(target)
      ActionCable.server.broadcast(channel_name, action: 'inline', target: target, content: inline,
                                                 id: id, field: field)
    end
  end
end
