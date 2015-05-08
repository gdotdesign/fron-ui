require 'fron_ui'

Fron::Sheet.helper.theme.font_family = 'Open Sans'

# Main
class Main < UI::Container
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  style fontSize: 14.px,
        position: :absolute,
        padding: -> { theme.spacing.em },
        top: 0,
        left: 0,
        right: 0,
        bottom: 0

  component :picker, UI::DatePicker

  component :box, UI::Box do
    component :calendar, UI::Calendar
  end
end

DOM::Document.body << Main.new
