# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'broadcast_hub.gemspec' do
  let(:gemspec_path) { Rails.root.join('engines/broadcast_hub/broadcast_hub.gemspec') }

  it 'declares jquery-rails runtime dependency' do
    specification = Gem::Specification.load(gemspec_path.to_s)
    dependency_names = specification.runtime_dependencies.map(&:name)

    expect(dependency_names).to include('jquery-rails')
  end
end
