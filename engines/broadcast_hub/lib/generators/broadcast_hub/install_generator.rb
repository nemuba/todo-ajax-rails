# frozen_string_literal: true

require 'rails/generators'

module BroadcastHub
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer
        template 'broadcast_hub.rb.tt', 'config/initializers/broadcast_hub.rb'
      end
    end
  end
end
