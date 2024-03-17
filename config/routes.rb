# frozen_string_literal: true

Rails.application.routes.draw do
  root 'todos#index'
  resources :todos do
    get 'confirm_delete', on: :member
    get 'inline', on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
