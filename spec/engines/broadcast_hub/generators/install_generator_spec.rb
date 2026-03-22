# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('engines/broadcast_hub/lib/generators/broadcast_hub/install_generator').to_s

RSpec.describe BroadcastHub::Generators::InstallGenerator do
  let(:destination_root) { Rails.root.join('tmp/generator_specs/broadcast_hub_install').to_s }
  let(:initializer_path) { File.join(destination_root, 'config/initializers/broadcast_hub.rb') }

  before do
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(destination_root)
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  it 'generates initializer with resolver context examples' do
    Rails::Generators.invoke(
      'broadcast_hub:install',
      [],
      destination_root: destination_root
    )

    expect(File).to exist(initializer_path)

    content = File.read(initializer_path)

    expect(content).to include('config.stream_key_resolver')
    expect(content).to include('current_user')
    expect(content).to include('session_id')
    expect(content).to include('ApplicationCable::Connection')
  end
end
