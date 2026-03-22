# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  render_views

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'legacy js.erb contract' do
    it 'keeps App.Todo.renderTodos when index has rows', js: true do
      create(:todo, user: user)

      get :index, format: :js

      expect(response).to have_http_status(:success)
      expect(response.body).to include('App.Todo.renderTodos(todos);')
    end

    it 'keeps App.Todo.renderTodos when index is empty', js: true do
      get :index, format: :js

      expect(response).to have_http_status(:success)
      expect(response.body).to include('App.Todo.renderTodos(empty);')
    end

    it 'keeps App.Todo.update legacy signature in inline update errors', js: true do
      todo = create(:todo, user: user)

      patch :update,
            params: { id: todo.id, todo: { title: '', inline_editing: true } },
            format: :js

      expect(response).to have_http_status(:success)
      expect(response.body).to include("App.Todo.update('#todos', todoId, todo);")
    end
  end
end
