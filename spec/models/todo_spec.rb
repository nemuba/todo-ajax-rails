# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1) }
  end

  describe 'attributes' do
    it { should respond_to(:field) }
    it { should respond_to(:inline_editing) }
  end

  describe 'includes' do
    describe 'Broadcaster' do
      it { expect(Todo.included_modules).to include(Broadcaster) }
      it { expect(Todo).to respond_to(:broadcast_to) }

      describe 'methods' do
        it { should respond_to(:turbo_stream_append) }
        it { should respond_to(:turbo_stream_prepend) }
        it { should respond_to(:turbo_stream_replace) }
        it { should respond_to(:turbo_stream_remove) }
        it { should respond_to(:turbo_stream_inline) }
      end
    end
  end
end
