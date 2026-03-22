# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastHub::Configuration do
  it 'defaults to strict payload version 1' do
    config = described_class.new

    expect(config.payload_version).to eq(1)
    expect(config.update_strategy).to eq(:replace_with)
    expect(config.allowed_resources).to eq([])
    expect(config.authorize_scope).to be_nil
  end
end
