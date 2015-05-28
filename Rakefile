require 'rubygems'
require 'bundler/setup'
require 'quality_control'
require 'quality_control/rubycritic'
require 'quality_control/rubocop'
require 'quality_control/yard'
require 'quality_control/opal_rspec'
require 'rack'
require 'fron_ui'

Bundler::GemHelper.install_tasks

QualityControl::Rubycritic.directories += %w(opal)
QualityControl::Yard.threshold = 75
QualityControl::OpalRspec.files = %r{^opal\/fron-ui\/.*\.rb}
QualityControl::OpalRspec.threshold = 90

QualityControl.tasks += %w(
  syntax:ruby
  documentation:coverage
  opal:rspec:coverage
  rubycritic:coverage
)

task :example do
  example = (ARGV[1] || 'todo')
  server = Opal::Server.new do |s|
    s.append_path 'examples'
    s.append_path "examples/#{example}"
    s.main = example
    s.debug = false
  end
  Rack::Handler::WEBrick.run server, Port: 9292
end
