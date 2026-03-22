# frozen_string_literal: true

require 'rails_helper'
require 'timeout'

RSpec.describe 'Jasmine runner', type: :feature, js: true do
  it 'executes JavaScript controller specs with non-zero examples and zero failures' do
    visit '/specs'

    Timeout.timeout(30) do
      loop do
        done = page.evaluate_script(<<~JS)
          (function() {
            if (!window.jsApiReporter) {
              return false;
            }

            if (typeof window.jsApiReporter.status === 'function') {
              return window.jsApiReporter.status() === 'done';
            }

            if (typeof window.jsApiReporter.finished === 'function') {
              return window.jsApiReporter.finished();
            }

            return window.jsApiReporter.finished === true;
          })();
        JS
        break if done

        sleep(0.1)
      end
    end

    total_specs = page.evaluate_script('window.jsApiReporter.specs().length')
    failures = page.evaluate_script("window.jsApiReporter.specs().filter(function(spec) { return spec.status === 'failed'; }).length")

    expect(total_specs).to be > 0
    expect(failures).to eq(0)
  end
end
