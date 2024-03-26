# frozen_string_literal: true

# TodoService
class TodoService
  attr_accessor :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def self.index(params, user)
    new(params, user).index
  end

  def index
    return sort if sort?
    return search if search?

    user.todos.limit(50)
  end

  private

  def search
    if status?
      user.todos.where(status: params[:status]).limit(50)
    else
      user.todos.where("#{field} LIKE ?", "%#{params[field]}%").limit(50)
    end
  end

  def sort
    user.todos.order(params[:sort] => params[:direction])
  end

  def field
    title? ? 'title' : 'description'
  end

  def search?
    params.keys.any? { |key| key.in? %w[title description status] }
  end

  def sort?
    params.keys.any? { |key| key.in? %w[sort direction] }
  end

  def title?
    params[:title].present?
  end

  def description?
    params[:description].present?
  end

  def status?
    params[:status].present?
  end
end
