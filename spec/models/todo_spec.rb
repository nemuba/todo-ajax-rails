# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, completed: 1) }
  end

  describe 'attributes' do
    it { is_expected.to respond_to(:field) }
    it { is_expected.to respond_to(:inline_editing) }
  end

  describe 'includes' do
    context 'when Broadcaster' do
      it { expect(described_class.included_modules).to include(Broadcaster) }
      it { expect(described_class).to respond_to(:broadcast_to) }
    end
  end
end
