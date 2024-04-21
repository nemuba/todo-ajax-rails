# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoChannel, type: :channel do
  let(:current_user) { create(:user) }

  context 'current_user is present' do
    before do
      stub_connection current_user: current_user
    end

    it 'subscribes to a stream' do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from("todo_channel_#{current_user.id}")
    end

    it 'broadcasts to the stream append' do
      subscribe
      todo = create(:todo, user: current_user)
      expect { perform :append, id: todo.id, target: 'todos' }.to have_broadcasted_to("todo_channel_#{current_user.id}")
    end

    it 'broadcasts to the stream prepend' do
      subscribe
      todo = create(:todo, user: current_user)
      expect { perform :prepend, id: todo.id, target: 'todos' }.to have_broadcasted_to("todo_channel_#{current_user.id}")
    end

    it 'broadcasts to the stream update' do
      subscribe
      todo = create(:todo, user: current_user)
      expect { perform :update, id: todo.id, target: 'todos' }.to have_broadcasted_to("todo_channel_#{current_user.id}")
    end
  end
end
