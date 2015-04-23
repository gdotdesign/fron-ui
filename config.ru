require 'bundler'
Bundler.require

require 'fron_ui'

run Opal::Server.new { |s|
  s.main = 'kitchensink'
  s.debug = false
}
