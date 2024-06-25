# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoService, type: :service do
  let(:params) { ActionController::Parameters.new({}) }
  let(:params_sort) { ActionController::Parameters.new({ direction: 'desc', sort: Todo.column_names.sample }) }
  let(:params_search) { ActionController::Parameters.new({ %w[title description].sample => Faker::Lorem.word }) }
  let(:user) { create(:user) }

  describe '#call' do
    before do
      create_list(:todo, 50, :with_user, user: user)
    end

    it 'returns todos' do
      expected = described_class.call(params, user)
      expect(expected.count).to eq(50)
    end

    it 'returns todos with sort' do
      expected = described_class.call(params_sort, user)
      expect(expected).to eq(user.todos.order_by(params_sort[:sort], params_sort[:direction]).limit(50))
    end

    it 'returns todos with search' do
      expected = described_class.call(params_search, user)
      expect(expected).to eq(user.todos.search(params_search.keys.first, params_search.values.first).limit(50))
    end
  end
end
