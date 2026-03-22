# frozen_string_literal: true

if Rake::Task.task_defined?('spec:javascript')
  Rake::Task['spec:javascript'].clear
end

namespace :spec do
  desc 'Run JavaScript specs via /specs Jasmine runner'
  task :javascript do
    sh 'bundle exec rspec --pattern spec/javascripts/**/*_spec.rb'
  end
end
