require 'fron_ui'

UI::Config.font_family = 'Open Sans'

class Projects < UI::Box
  class Item < UI::Container
    extend Forwardable

    tag 'ui-item'

    def_delegators :span, :text=, :text

    component :span, :span
    component :icon, UI::Icon, glyph: :remove

    style span: { flex: 1 },
          padding: -> { UI::Config.spacing.em },
          color: -> { UI::Config.colors.font },
          fontFamily: -> { UI::Config.font_family }
  end

  tag 'ui-projects'

  style input: { flex: 1 },
        display: :flex,
        flexDirection: :column,
        height: 300.px,
        'ui-list' => {
          flex: 1,
        }

  component :title, UI::Title, text: 'Projects'
  component :container, UI::Container do
    component :input, UI::Input, placeholder: 'Add Project...'
    component :button, UI::Button, shape: :square do
      component :icon, UI::Icon, glyph: :plus
    end
  end
  component :list, UI::List do
    (0..20).each do
      component :item, Item, text: 'ASDASD'
    end
  end

  def initialize
    super
    self[:direction] = :column
  end
end

class Main < Fron::Component
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  style fontSize: 14.px

  component :conatiner, UI::Container do
    component :projects, Projects

    component :box, UI::Box do
      component :container, UI::Container, direction: :column do
        component :button, UI::Button, text: 'Hello There!'
        component :button, UI::Button, text: 'Danger!', type: :danger
        component :button, UI::Button, text: 'Success!', type: :success
        component :button, UI::Checkbox
      end
    end
  end
end

DOM::Document.body << Main.new
