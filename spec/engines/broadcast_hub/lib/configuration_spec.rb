# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastHub::Configuration do
  it 'defaults to strict payload version 1' do
    config = described_class.new

    expect(config.payload_version).to eq(1)
    expect(config.update_strategy).to eq(:replace_with)
  end
end
