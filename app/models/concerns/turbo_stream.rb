# frozen_string_literal: true

module TurboStream
  include TurboActions
  extend ActiveSupport::Concern

  included do
    def action_view
      @action_view = ApplicationController.renderer.new
      @action_view.extend(TodosHelper)
    end

    # templates
    def append
      action_view.todo_partials('todo', locals: { todo: self })
    end

    def replace
      action_view.todo_partials('todo', locals: { todo: self })
    end

    def inline
      action_view.todo_partials('inline', locals: { todo: self, field: field })
    end
  end
end
