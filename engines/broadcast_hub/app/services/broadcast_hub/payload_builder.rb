# frozen_string_literal: true

module BroadcastHub
  class PayloadBuilder
    class ValidationError < StandardError; end

    VALID_ACTIONS = %w[append prepend update remove].freeze
    ACTIONS_REQUIRING_CONTENT = %w[append prepend update].freeze
    ALLOWED_KEYS = %i[version action target content id meta].freeze

    class << self
      def build(action:, target:, content:, id:, meta: {})
        validate_action!(action)
        validate_target!(target)
        validate_content!(action, content)

        payload = {
          version: BroadcastHub.configuration.payload_version,
          action: action,
          target: target,
          content: content,
          id: id,
          meta: normalize_meta(meta)
        }

        payload.slice(*ALLOWED_KEYS)
      end

      private

      def validate_action!(action)
        raise ValidationError, 'invalid action' unless VALID_ACTIONS.include?(action)
      end

      def validate_target!(target)
        raise ValidationError, 'target required' if target.to_s.strip.empty?
      end

      def validate_content!(action, content)
        return unless ACTIONS_REQUIRING_CONTENT.include?(action)
        raise ValidationError, 'content required' if content.to_s.strip.empty?
      end

      def normalize_meta(meta)
        return {} if meta.nil?
        raise ValidationError, 'meta must be a hash' unless meta.is_a?(Hash)

        meta
      end
    end
  end
end
