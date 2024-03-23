# frozen_string_literal: true

Rails.application.routes.draw do
  root "app#index"
  resources :todos do
    get "confirm_delete", on: :member
    get "inline", on: :member
    get "more", on: :member
    get "datatable", on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
