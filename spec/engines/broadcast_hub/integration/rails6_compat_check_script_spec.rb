# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BroadcastHub Rails 6 compatibility check scaffold' do
  let(:engine_root) { Rails.root.join('engines/broadcast_hub') }
  let(:script_path) { engine_root.join('script/rails6_compat_check') }
  let(:gemfile_path) { engine_root.join('gemfiles/rails_6_1.gemfile') }

  it 'ships a rails 6 bundle definition and check script' do
    expect(File).to exist(gemfile_path)
    expect(File).to exist(script_path)
  end

  it 'wires the check script to the rails 6 smoke spec' do
    content = File.read(script_path)

    expect(content).to include('rails_6_1.gemfile')
    expect(content).to include('rails6_smoke_spec.rb')
    expect(content).to include('BUNDLE_GEMFILE')
  end
end
