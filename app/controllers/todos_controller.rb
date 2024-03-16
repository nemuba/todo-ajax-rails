# frozen_string_literal: true

# TodosController
class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy confirm_delete]
  before_action :instance_todo, only: %i[create]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  # GET /todos/1 or /todos/1.json
  def show; end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit; end

  # POST /todos or /todos.json
  def create
    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_url, notice: I18n.t('messages.todo.created') }
        format.json { render :show, status: :created, location: @todo }
      else
        format.js
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_url, notice: I18n.t('messages.todo.updated') }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.js
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
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
    respond_to do |format|
      if @todo.destroy
        format.html { redirect_to todos_url, notice: I18n.t('messages.todo.destroyed') }
      else
        format.js
        format.html { redirect_to todos_url, notice: I18n.t('messages.todo.not_destroyed') }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params[:id])
  end

  def instance_todo
    @todo = Todo.new(todo_params)
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params.require(:todo).permit(:title, :description, :status)
  end
end
