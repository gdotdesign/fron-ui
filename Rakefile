require 'rubygems'
require 'bundler/setup'
require 'opal/rspec/rake_task'
require 'rack'
require 'fron_ui'

Bundler::GemHelper.install_tasks

html = -> (file) { "<body><script src='/assets/#{file}.js'></script><script>Opal.modules[\"#{file}\"](Opal)</script></body>" }

Opal::RSpec::RakeTask.new(:spec) do |_, task|
  task.files = FileList[ARGV[1] || 'spec/**/*_spec.rb']
  task.timeout = 120_000
end

desc 'Run CI Tasks'
task :ci do
  sh 'SPEC_OPTS="--color" rake spec'
  sh 'rubocop lib opal spec'
  sh 'rubycritic lib opal --mode-ci -s 94 --no-browser'
end

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
