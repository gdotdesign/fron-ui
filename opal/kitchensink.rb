require 'fron_ui'

UI::Config.font_family = 'Open Sans'

class Projects < UI::Box
  class Item < UI::Container
    extend Forwardable

    tag 'ui-item'

    def_delegators :span, :text=, :text

    component :span, :span
    component :button, 'ui-action' do
      component :icon, UI::Icon, glyph: :remove
    end

    style span: { flex: 1 },
          padding: -> { UI::Config.spacing.em },
          color: -> { UI::Config.colors.font },
          fontFamily: -> { UI::Config.font_family }

    on :click, 'ui-action', :remove!
  end

  tag 'ui-projects'

  style input: { flex: 1 },
        flex: 1,
        'ui-list' => { flex: 1 }

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

class Main < UI::Container
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  style fontSize: 14.px,
        position: :absolute,
        padding: -> { UI::Config.spacing.em },
        top: 0,
        left: 0,
        right: 0,
        bottom: 0

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

DOM::Document.body << Main.new
