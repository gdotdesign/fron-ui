require 'fron_ui'

class String
  def to_class
    split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end
end

class Item < UI::Label
  include Record

  def render
    self.text = @data[:id]
  end
end

class List < UI::List
  include UI::Behaviors::SelectableChildren
end

class Demo < UI::Box
  style display: :flex,
        justifyContent: :center,
        alignItems: :center,
        '> *' => {
          maxHeight: '80%',
          maxWidth: '60%'
        }
end

class Theme < UI::Box
  include UI::Behaviors::Serialize

  component :title, UI::Title, text: 'Theme'
  component :border, UI::NumberRange, name: :border_radius, step: 0.1, value: 0.15
  component :border, UI::NumberRange, name: :spacing, step: 0.1, value: 0.75
  component :border, UI::NumberRange, name: :size, step: 0.1, value: 2.2
  component :border, UI::NumberRange, name: :font_size, step: 1, value: 16

  on :input, :set
  on :change, :set

  def set
    data.each do |key, value|
      if key == :font_size
        DOM::Document.body.style.fontSize = value.px
      else
        Fron::Sheet.helper.theme[key] = value
        Fron::Sheet.render
      end
    end
  end
end

class Main < UI::Container
  tag 'main'

  style padding: -> { theme.spacing.em },
        margin: '0 auto',
        height: '96vh'

  component :container, UI::Container, direction: :row, flex: 1 do
    component :sidebar, UI::Box do
      component :title, UI::Title, text: 'Components'
      component :list, List, base: ::Item
    end

    component :demo, Demo, flex: 1 do
    end

    component :theme, Theme
  end

  on :selected_change, :populate

  def populate(event)
    data = event.target.selected.data
    el = data[:id].to_class.new
    data[:args].to_a.each do |key, value|
      if el.respond_to?("#{key}=")
        el.send("#{key}=", value)
      else
        el[key] = value
      end
    end
    request_animation_frame do
      @container.demo.empty
      @container.demo << el
    end
  end
end

Fron::Sheet.helper.theme.font_family = 'Open Sans'
Fron::Sheet.stylesheet '//fonts.googleapis.com/css?family=Open+Sans:400,600,700'
Fron::Sheet.add_rule 'body', { margin: 0, fontSize: 16.px }, '0'

data = [
  { id: 'UI::Button', args: { text: 'Button...' }, options: {} },
  { id: 'UI::DatePicker' },
  { id: 'UI::Checkbox', args: { checked: true } },
  { id: 'UI::Calendar' }
]

main = Main.new
main.container.sidebar.list.items = data

DOM::Document.body << main
