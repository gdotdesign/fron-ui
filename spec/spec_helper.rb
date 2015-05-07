require 'rspec_coverage_helper'
require 'fron_ui'

require 'support/matchers/position'
require 'support/matchers/size'
require 'fron/event_mock'

%x{
  window.requestAnimationFrame = function(callback){ callback() }
  window.setTimeout = function(callback) { callback() }
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

# Test Helpers
module TestHelpers
  def in_dom(el)
    return if DOM::Document.body.include?(el)
    el = el.parent while el.parent
    el >> DOM::Document.body
    yield
  ensure
    el.remove!
  end
end

RSpec.configure do |config|
  config.include TestHelpers
  config.before do
    allow_any_instance_of(Fron::Logger).to receive(:info)
  end
end
