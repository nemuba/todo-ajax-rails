# frozen_string_literal: true

class AppController < ApplicationController
  before_action :authenticate_user!

  def index; end
end
