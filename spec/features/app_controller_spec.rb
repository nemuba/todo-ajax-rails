# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Root path', type: :feature do
  let(:user) { create(:user) }

  it 'Visitor without login' do
    visit root_path
    expect(page).to have_selector('h2', text: 'Log in')
  end

  it 'Visitor sees welcome text' do
    login_as(user)
    visit root_path
    expect(page).to have_selector('h1', text: 'Tarefa')
  end

  it 'Visitor sees user email' do
    login_as(user)
    visit root_path
    expect(page).to have_selector('li', text: user.email)
  end

  it 'Visitor sees logout link' do
    login_as(user)
    visit root_path
    expect(page).to have_selector('a', text: 'Sign out')
  end

  it 'Visitor sees new todo link' do
    login_as(user)
    visit root_path
    expect(page).to have_selector('a', text: 'Nova Tarefa', class: 'btn btn-sm btn-primary')
  end

  it 'Visitor sees todo list' do
    login_as(user)
    visit root_path
    expect(page).to have_selector('table', id: 'todos_datatable')
  end

  # scenario "Visitor add new todo", js: true do
  #   login_as(user)
  #   visit root_path
  #   click_link 'Nova Tarefa'
  #   sleep(5) # espera 5 segundos
  #   # o restante do seu teste
  # end
end
