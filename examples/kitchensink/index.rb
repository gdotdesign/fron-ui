require 'fron_ui'

class UI::Panel < UI::Box
  extend Forwardable

  tag 'ui-panel'

  def_delegators :title, :align=
  def_delegators :container, :children, :html, :html=, :text, :text=, :direction, :direction=

  component_delegators :container, :<<, :insertBefore, :component

  component :title, UI::Title
  component :container, UI::Container

  def title=(value)
    @title.text = value
  end
end

class Main < UI::Container
  tag 'main'

  style fontSize: 14.px,
        padding: -> { theme.spacing.em },
        maxWidth: 960.px,
        margin: '0 auto'

  component :box, UI::Panel, title: 'Button', direction: :row do
    component :button, UI::Button, text: 'Primary'
    component :button, UI::Button, text: 'Danger', type: :danger
    component :button, UI::Button, text: 'Success', type: :success
  end

  component :box, UI::Panel, title: 'Checkbox', direction: :row do
    component :checkbox, UI::Checkbox
    component :checkbox, UI::Checkbox, checked: true
  end

  component :icon, UI::Panel, title: 'Icons', direction: :row do
    component :icon, UI::Icon, glyph: :plus
    component :icon, UI::Icon, glyph: :clock
    component :icon, UI::Icon, glyph: :remove
  end

  component :range, UI::Panel do
    component :range, UI::NumberRange, min: 0, max: 100, step: 0.1
  end
end

Fron::Sheet.helper.theme.font_family = 'Open Sans'
Fron::Sheet.stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
Fron::Sheet.add_rule 'body', { margin: 0 }, '0'

DOM::Document.body << Main.new
