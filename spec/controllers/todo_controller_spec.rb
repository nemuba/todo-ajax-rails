# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #datatable' do
    it 'returns http success' do
      get :datatable
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success', js: true do
      get :show, params: { id: create(:todo, user_id: user.id).id }, format: :js
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success', js: true do
      get :edit, params: { id: create(:todo, user_id: user.id).id }, format: :js
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success', js: true do
      get :new, format: :js
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns http success', js: true do
      post :create, params: { todo: attributes_for(:todo, user_id: user.id) }, format: :js
      expect(response).to have_http_status(:success)
    end

    it 'increases the number of todos by 1' do
      expect do
        post :create, params: { todo: attributes_for(:todo, :with_user) }, format: :js
      end.to change(Todo, :count).by(1)
    end

    it 'broadcasts to the todos channel' do
      expect do
        post :create,
             params: { todo: attributes_for(:todo, user_id: user.id) },
             format: :js
      end.to have_broadcasted_to("todo_channel_#{user.id}").from_channel(TodoChannel)
    end
  end

  describe 'PATCH #update' do
    let(:todo) { create(:todo, user_id: user.id) }

    it 'returns http success', js: true do
      patch :update, params: { id: todo.id, todo: { title: 'New title' } }, format: :js
      expect(response).to have_http_status(:success)
    end

    it 'broadcasts to the todos channel' do
      expect do
        patch :update,
              params: { id: todo.id, todo: { title: 'New title' } },
              format: :js
      end.to have_broadcasted_to("todo_channel_#{user.id}").at_least(:once)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success', js: true do
      todo = create(:todo, user_id: user.id)
      delete :destroy, params: { id: todo.id }, format: :js
      expect(response).to have_http_status(:success)
    end

    it 'decreases the number of todos by 1' do
      todo = create(:todo, user_id: user.id)
      expect { delete :destroy, params: { id: todo.id }, format: :js }.to change(Todo, :count).by(-1)
    end

    it 'broadcasts to the todos channel' do
      todo = create(:todo, user_id: user.id)
      expect do
        delete :destroy,
               params: { id: todo.id },
               format: :js
      end.to have_broadcasted_to("todo_channel_#{user.id}").from_channel(TodoChannel)
    end
  end

  describe 'GET #confirm_delete' do
    it 'returns http success', js: true do
      get :confirm_delete, params: { id: create(:todo, user_id: user.id).id }, format: :js
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #inline' do
    it 'returns http success', js: true do
      get :inline, params: { id: create(:todo, user_id: user.id).id, field: 'title' }, format: :js
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #more' do
    it 'returns http success', js: true do
      get :more, params: { id: create(:todo, user_id: user.id).id }, format: :js
      expect(response).to have_http_status(:success)
    end
  end
end
