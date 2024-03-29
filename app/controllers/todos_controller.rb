# frozen_string_literal: true

# TodosController
class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[show edit update destroy confirm_delete inline more]
  before_action :instance_todo, only: %i[create]

  # GET /todos or /todos.json
  def index
    @todos = TodoService.index(params, current_user)
  end

  def datatable
    @todos = TodoService.index(params, current_user)

    send_data render_to_string(partial: 'todos/partials/todo', collection: @todos)
  end

  def more
    respond_to do |format|
      format.js
    end
  end

  # GET /todos/1 or /todos/1.json
  def show; end

  # GET /todos/new
  def new
    @todo = current_user.todos.build
  end

  # GET /todos/1/edit
  def edit; end

  # POST /todos or /todos.json
  def create
    @todo.save

    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    @todo.update(todo_params)

    respond_to do |format|
      format.js
    end
  end

  # GET /todos/1/confirm_delete
  def confirm_delete
    respond_to do |format|
      format.js
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.js
    end
  end

  def inline
    respond_to do |format|
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def instance_todo
    @todo = current_user.todos.build(todo_params)
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params.require(:todo).permit(:title, :description, :status, :inline_editing)
  end
end
