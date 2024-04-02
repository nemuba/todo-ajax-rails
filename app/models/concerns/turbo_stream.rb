# frozen_string_literal: true

module TurboStream
  extend ActiveSupport::Concern
  include TurboActions

  included do
    def action_cable
      @action_cable ||= ActionCable.server
    end

    delegate :broadcast, to: :action_cable

    def action_view
      @action_view ||= ApplicationController.renderer.new
      @action_view.extend("#{class_name.pluralize.camelize}Helper".constantize)
    end

    def channel_name
      "#{class_name.downcase}_channel_#{user_id}"
    end

    def class_name
      self.class.name
    end

    def render_partial(partial_name, locals = {})
      action_view.send("#{class_name.downcase}_partials", partial_name, locals: locals)
    end

    def partial
      render_partial('todo', { todo: self })
    end

    def inline
      render_partial('inline', { todo: self, field: field })
    end
  end
end
