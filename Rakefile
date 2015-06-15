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

QualityControl::Rubycritic.directories += Dir.glob('opal/*/*') - ['opal/fron-ui/examples']
QualityControl::Yard.threshold = 100
QualityControl::OpalRspec.files = %r{^opal\/fron-ui\/.*\.rb}
QualityControl::OpalRspec.threshold = 100

QualityControl.tasks += %w(
  syntax:ruby
  documentation:coverage
  opal:rspec:coverage
  rubycritic:coverage
)

html = -> (file) { "<body><script src='/assets/#{file}.js'></script></body>" }

task :examples do
  opal = Opal::Server.new do |s|
    s.main = nil
    s.debug = false
  end

  app = proc do |env|
    next [404, {}, []] if env['PATH_INFO'] =~ %r{^/assets}
    example = env['PATH_INFO'][1..-1]
    ['200', { 'Content-Type' => 'text/html' }, [html.call("fron-ui/examples/#{example}/index")]]
  end

  server = Rack::Cascade.new([app, opal])
  Rack::Handler::WEBrick.run server, Port: 9292
end
