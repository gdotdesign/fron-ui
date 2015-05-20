%x{
  window.requestAnimationFrame = function(callback){ callback() }
  window.clearTimeout = function() { return true }
  window.alert = function(text) { return 'alert' }
  window.confirm = function(text) { return true }
  window.prompt = function(text, value) { return value }

  window.FileReader = function(){}
  window.FileReader.prototype.readAsDataURL = function(){
    return 'data:image/gif;base64,R0lGODlhyAAiALM...DfD0QAADs='
  }

  window.throttle = function(fn){ return fn }
  window.debounce = function(fn){ return fn }
}

require 'rspec_coverage_helper'
require 'fron_ui'

require 'support/matchers/position'
require 'support/matchers/size'
require 'fron/event_mock'

# Test Helpers
module TestHelpers
  def timeout(ms = 0)
    `setTimeout(function(){#{yield}},#{ms})`
  end
end

RSpec.configure do |config|
  config.include TestHelpers
  config.before do
    allow_any_instance_of(Fron::Logger).to receive(:info)
    allow(Kernel).to receive(:timeout).and_yield
  end
end
