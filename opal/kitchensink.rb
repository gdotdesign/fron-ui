require 'fron_ui'

class Main < Fron::Component
  component :button, UI::Button, text: 'Hello There!', type: :primary
end


DOM::Document.body << Main.new
