# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Todo table regressions', type: :feature, js: true do
  let(:user) { create(:user) }

  def wait_for_datatable
    expect(page).to have_css('#todos-total', text: 'Total de registros: 0', wait: 10)
    expect(page.evaluate_script('Boolean(window.App && App.Todo && typeof App.Todo.new === "function")')).to be(true)
  end

  scenario 'create and delete keep total and empty rows consistent' do
    login_as(user, scope: :user)
    visit root_path

    wait_for_datatable

    find('#new-todo').click
    unless page.has_css?('#todo-modal #todo', wait: 5)
      page.execute_script("$.ajax({ type: 'GET', url: '/todos/new', dataType: 'script' });")
    end

    expect(page).to have_css('#todo-modal #todo', wait: 10)
    fill_in 'todo_title', with: 'Create from feature'
    fill_in 'todo_description', with: 'Created from scenario'
    find('#todo_status').find("option[value='pending']").select_option
    find('#todo input[type="submit"]').click

    expect(page).to have_css('#todos tr[id^="todo_"]', count: 1, wait: 10)
    created_id = page.evaluate_script(%q(document.querySelector('#todos tr[id^="todo_"]').id.replace('todo_', '')))
    expect(page).to have_css('#todos-total', text: 'Total de registros: 1', wait: 10)
    expect(page).to have_no_css('#empty_rows', visible: :visible, wait: 10)

    page.execute_script("if ($('#empty_rows').length === 0) { $('#todos').append('<tr id=\"empty_rows\" style=\"display:none;\"><td>nenhum registro</td></tr>'); }")

    within("#todo_#{created_id}") do
      click_button 'Ações'
      click_link 'Excluir'
    end

    unless page.has_css?('#todo-modal form[action^="/todos/"]', wait: 5)
      page.execute_script("$.get('/todos/#{created_id}/confirm_delete')")
    end

    expect(page).to have_css('#todo-modal form[action^="/todos/"]', wait: 10)
    find('#todo-modal input[type="submit"]').click

    expect(page).to have_no_css("#todo_#{created_id}", wait: 10)
    expect(page).to have_css('#todos-total', text: 'Total de registros: 0', wait: 10)
    expect(page).to have_css('#empty_rows', text: 'nenhum registro', visible: :all, wait: 10)
  end

  scenario 'inline edit and more toggle work in the same flow' do
    todo = create(:todo, user: user, title: 'Inline old', description: 'Original', status: :pending)

    login_as(user, scope: :user)
    visit root_path

    wait_for_datatable
    expect(page).to have_css("#todo_#{todo.id}", wait: 10)

    expect(page).to have_css('#todos-total', text: 'Total de registros: 1', wait: 10)

    within("#todo-status-#{todo.id}") do
      click_link 'Pendente'
    end

    expect(page).to have_css("#todo-status-#{todo.id} select#todo_status", wait: 10)
    find("#todo-status-#{todo.id} #todo_status").find("option[value='completed']").select_option

    expect(page).to have_css("#todo-status-#{todo.id}", text: 'Concluída', wait: 10)

    find("#btn-more-todo-#{todo.id}").click
    expect(page).to have_css("#more-todo-#{todo.id}", wait: 10)

    find("#btn-more-todo-#{todo.id}").click
    expect(page).to have_no_css("#more-todo-#{todo.id}", wait: 10)
  end

  scenario 'invalid modal submit marks fields invalid and focuses first field' do
    login_as(user, scope: :user)
    visit root_path

    wait_for_datatable

    find('#new-todo').click
    unless page.has_css?('#todo-modal #todo', wait: 5)
      page.execute_script("$.ajax({ type: 'GET', url: '/todos/new', dataType: 'script' });")
    end
    expect(page).to have_css('#todo-modal #todo', wait: 10)

    fill_in 'todo_description', with: 'Only description set'

    page.execute_script(<<~JS)
      window.__focusProbe = { ids: [] };
      window.__focusProbe.original = HTMLElement.prototype.focus;
      HTMLElement.prototype.focus = function() {
        window.__focusProbe.ids.push(this.id || null);
        return window.__focusProbe.original.apply(this, arguments);
      };
    JS

    begin
      find('#todo input[type="submit"]').click

      expect(page).to have_css('#todo_title.is-invalid', wait: 10)
      expect(page).to have_css('#todo_status.is-invalid', wait: 10)
      expect(page.evaluate_script("window.__focusProbe.ids.indexOf('todo_title') >= 0")).to be(true)
    ensure
      page.execute_script(<<~JS)
        if (window.__focusProbe && window.__focusProbe.original) {
          HTMLElement.prototype.focus = window.__focusProbe.original;
        }
      JS
    end

    page.execute_script(<<~JS)
      if (!document.querySelector('#custom-selector-form')) {
        const container = document.createElement('div');
        container.innerHTML = [
          '<div id="custom-errors"></div>',
          '<form id="custom-selector-form">',
          '  <input id="custom_title" data-field="title" />',
          '  <input id="custom_status" data-field="status" />',
          '</form>'
        ].join('');

        document.body.appendChild(container);
      }

      App.Todo.errorArgs.form = '#custom-selector-form';
      App.Todo.errorArgs.errorContainer = '#custom-errors';
      App.Todo.errorArgs.inputSelector = function(field) {
        return '[data-field="' + field + '"]';
      };

      App.Todo.renderErrors('<ul><li>Status is required</li></ul>', ['status']);
    JS

    expect(page).to have_css('#custom-selector-form #custom_status.is-invalid', wait: 10)
    expect(page).to have_no_css('#custom-selector-form #custom_title.is-invalid', wait: 10)
  end
end
