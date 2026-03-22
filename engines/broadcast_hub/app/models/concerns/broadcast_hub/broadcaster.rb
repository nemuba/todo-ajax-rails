# frozen_string_literal: true

module BroadcastHub
  module Broadcaster
    extend ActiveSupport::Concern

    def broadcast_append(target)
      broadcast_action('append', target)
    end

    def broadcast_prepend(target)
      broadcast_action('prepend', target)
    end

    def broadcast_update(target)
      broadcast_action('update', target)
    end

    def broadcast_remove(target)
      broadcast_action('remove', target)
    end

    class_methods do
      def broadcast_to(resource_name, partial:, target:)
        define_method(:broadcast_hub_resource_name) { resource_name.to_s }
        define_method(:broadcast_hub_partial) { partial }
        define_method(:broadcast_hub_target) { target }

        after_create_commit { broadcast_append(broadcast_hub_target) }
        after_update_commit { broadcast_update(broadcast_hub_target) }
        after_destroy_commit { broadcast_remove(broadcast_hub_target) }
      end
    end

    private

    def broadcast_action(action, target)
      content = action == 'remove' ? nil : render_broadcast_content
      payload = BroadcastHub::PayloadBuilder.build(
        action: action,
        target: target,
        content: content,
        id: broadcast_hub_dom_id,
        meta: {}
      )

      ActionCable.server.broadcast(broadcast_hub_stream_key, payload)
    end

    def render_broadcast_content
      BroadcastHub::Renderer.new.render(
        partial: broadcast_hub_partial,
        locals: { self.class.model_name.singular.to_sym => self }
      )
    end

    def broadcast_hub_stream_key
      resolver = BroadcastHub.configuration.stream_key_resolver
      raise 'stream_key_resolver not configured' unless resolver

      context_attributes = {
        tenant_id: nil,
        current_user: nil,
        session_id: nil,
        params: {}
      }.merge((broadcast_hub_stream_key_context_attributes || {}).to_h)

      resolver.call(
        BroadcastHub::StreamKeyContext.new(
          resource_name: broadcast_hub_resource_name,
          tenant_id: context_attributes[:tenant_id],
          current_user: context_attributes[:current_user],
          session_id: context_attributes[:session_id],
          params: context_attributes[:params]
        )
      )
    end

    def broadcast_hub_stream_key_context_attributes
      {
        tenant_id: nil,
        current_user: nil,
        session_id: nil,
        params: {}
      }
    end

    def broadcast_hub_dom_id
      "#{self.class.model_name.singular}_#{id}"
    end
  end
end
