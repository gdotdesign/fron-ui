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
require 'fron_ui'
require 'fron/event_mock'

module TestHelpers
  def mock_drag(drag, left = 0, top = 0)
    target = drag.base
    move_blocks = []
    allow(drag).to receive(:request_animation_frame) do |&block|
      move_blocks << block
    end
    target.trigger :mousedown, pageX: 0, pageY: 0
    DOM::Document.body.trigger :mousemove, pageX: left, pageY: top
    move_blocks.each(&:call)
    DOM::Document.body.trigger :mouseup, pageX: left, pageY: top
  end
end

RSpec.configure do |config|
  config.include TestHelpers
  config.before do
    DOM::Document.body.off
    allow_any_instance_of(Fron::Logger).to receive(:info)
  end
end
