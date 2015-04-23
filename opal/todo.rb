require 'fron_ui'

class Todos < UI::Box
  class Item < UI::Container
    extend Forwardable

    tag 'ui-item'

    def_delegators :span, :text=, :text

    component :checkbox, UI::Checkbox
    component :span, :span
    component :icon, UI::Icon, glyph: :remove, clickable: true

    style span: { flex: 1 },
          padding: -> { UI::Config.spacing.em },
          color: -> { UI::Config.colors.font },
          fontFamily: -> { UI::Config.font_family },
          'ui-checkbox' => {
            height: '1.4em',
            width: '1.4em'
          }

    on :click, 'ui-icon', :remove!
  end

  include Behaviors::Enter
  include Behaviors::Actions

  tag 'ui-projects'

  enter :add

  style input: { flex: 1 },
        minHeight: 500.px,
        flex: 1,
        'ui-list' => {
          flex: 1,
          '&:empty:after' => {
            content: "'No items yet!'",
            display: :block,
            padding: -> { (UI::Config.spacing * 3).em },
            fontSize: '2em',
            opacity: 0.5,
            textAlign: :center
          }
        }

  component :title, UI::Title, text: 'Todos'
  component :container, UI::Container do
    component :input, UI::Input, placeholder: 'Add Item...'
    component :button, UI::Button, shape: :square, action: :add do
      component :icon, UI::Icon, glyph: :plus
    end
  end
  component :list, UI::List

  def add
    item = Item.new
    item.text = @container.input.value
    item >> @list
    @container.input.value = ''
  end
end

class Main < UI::Container
  stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
  style fontSize: 14.px,
        fontFamily: -> { UI::Config.font_family },
        padding: -> { UI::Config.spacing.em },
        width: 600.px,
        margin: '0 auto'

  component :todos, Todos, direction: :column
end

UI::Config.font_family = 'Open Sans'
DOM::Document.body << Main.new
