# frozen_string_literal: true

# TodosService
class TodosService
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def self.index(params)
    new(params).index
  end

  def index
    if sort?
      sort
    else
      return search(:title) if title?
      return search(:description) if description?
      return search(:status) if status?

      Todo.all
    end
  end

  private

  def search(field)
    if field == :status
      Todo.where(status: params[:status])
    else
      Todo.where("#{field} LIKE ?", "%#{params[field]}%")
    end
  end

  def sort
    Todo.order(params[:sort] => params[:direction])
  end

  def search?
    params[:search].present?
  end

  def sort?
    params[:sort].present?
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
