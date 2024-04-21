# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationService, type: :service do
  describe '.call' do
    it 'raises a NotImplementedError' do
      expect { described_class.call }.to raise_error(NotImplementedError)
    end
  end

  describe '#initialize' do
    it 'correctly initializes with arguments' do
      args = [1, 2, 3]
      service = described_class.new(*args)
      expect(service.args).to eq(args)
    end
  end
end
