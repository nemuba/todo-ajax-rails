# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoChannel, type: :channel do
  let(:current_user) { create(:user) }
  let(:todo) { create(:todo, user: current_user) }

  context 'when current_user is present' do
    before do
      stub_connection current_user: current_user
      subscribe
    end

    it 'subscribes to a stream' do
      expect(subscription).to have_stream_from("todo_channel_#{current_user.id}")
    end

    it 'broadcasts to the stream append' do
      expect { perform :append, id: todo.id, target: 'todos' }.to have_broadcasted_to("todo_channel_#{current_user.id}")
    end

    it 'broadcasts to the stream prepend' do
      expect do
        perform :prepend, id: todo.id, target: 'todos'
      end.to have_broadcasted_to("todo_channel_#{current_user.id}")
    end

    it 'broadcasts to the stream update' do
      expect { perform :update, id: todo.id, target: 'todos' }.to have_broadcasted_to("todo_channel_#{current_user.id}")
    end
  end
end
