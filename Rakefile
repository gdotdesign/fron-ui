require 'rack'
require 'fron_ui'

task :example do
  example = (ARGV[1] || 'todo')
  server = Opal::Server.new { |s|
    s.append_path 'examples'
    s.append_path "examples/#{example}"
    s.main = example
    s.debug = false
  }
  Rack::Handler::WEBrick.run server, Port: 9292
end
