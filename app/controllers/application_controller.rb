# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery except: %i[new show edit]
end
