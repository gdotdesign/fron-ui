require 'fron_ui'

UI::Config.font_family = 'Open Sans'

class Main < UI::Container
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  style fontSize: 14.px,
        position: :absolute,
        padding: -> { UI::Config.spacing.em },
        top: 0,
        left: 0,
        right: 0,
        bottom: 0

  component :box, UI::Box do
    component :container, UI::Container, direction: :column do
      component :button, UI::Button, text: 'Hello There!'
      component :button, UI::Button, text: 'Danger!', type: :danger
      component :button, UI::Button, text: 'Success!', type: :success
      component :button, UI::Checkbox
    end
  end
end

DOM::Document.body << Main.new
