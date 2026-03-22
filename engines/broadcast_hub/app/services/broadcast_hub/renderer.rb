# frozen_string_literal: true

module BroadcastHub
  class Renderer
    def initialize(renderer: ApplicationController.renderer)
      @renderer = renderer
    end

    def render(partial:, locals: {})
      @renderer.render(partial: partial, locals: locals)
    end
  end
end
