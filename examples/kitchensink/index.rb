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

  style padding: -> { theme.spacing.em }

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
          maxHeight: '85%',
          maxWidth: '85%'
        }
end

class Field < UI::Container
  extend Forwardable

  component :label, UI::Label, flex: 1

  def_delegators :input, :value, :value=
  def_delegators :label, :text, :text=

  style width: 20.em
end

class CheckboxField < Field
  component :input, UI::Checkbox

  style 'ui-checkbox' => { order: 1,
                           marginLeft: 0 },
        'ui-label' => { order: 2,
                        lineHeight: 2.em,
                        marginLeft: -> { theme.spacing.em } }

  def initialize
    super
    self[:direction] = :row
    self.compact = true
  end
end

class InputField < Field
  component :input, UI::Input
end

class RangeField < Field
  component :input, UI::NumberRange
end

class Theme < UI::Box
  include UI::Behaviors::Serialize
  include UI::Behaviors::Render

  component :title, UI::Title, text: 'Theme'

  on :change, :set

  def initialize
    super
    Fron::Sheet.helper.theme.to_h.each do |key, value|
      create_input key, value
    end
    Fron::Sheet.helper.colors.to_h.each do |key, value|
      input = UI::ColorPicker.new
      input[:name] = key
      input.value = value
      self << input
    end
  end

  def create_input(key, value)
    return unless value.class == Numeric
    input = UI::NumberRange.new
    input[:name] = key
    input.step = 0.1
    input.value = value
    input.affix = :em
    input.label = "#{key}:"
    self << input
  end

  def set(event)
    key = event.target[:name]
    value = event.target.value
    if key == :font_size
      DOM::Document.body.style.fontSize = value.px
    elsif value.to_s.start_with?('#')
      Fron::Sheet.helper.colors[key] = value
      Fron::Sheet.render
    else
      Fron::Sheet.helper.theme[key] = value
      Fron::Sheet.render
    end
  end
end

class Main < UI::Container
  tag 'main'

  style padding: -> { theme.spacing.em },
        boxSizing: 'border-box',
        overflow: :hidden,
        margin: '0 auto',
        height: '100vh',
        '> ui-container > ui-container > ui-box' => {
          flexWrap: :wrap,
          height: 10.3.em
        }

  component :container, UI::Container, direction: :row, flex: 1 do
    component :sidebar, UI::Box do
      component :title, UI::Title, text: 'Components'
      component :list, List, base: ::Item
    end

    component :demo_container, UI::Container, flex: 1 do
      component :demo, Demo, flex: 1
      component :options, UI::Box
    end

    component :theme, Theme
  end

  on :selected_change, 'list', :populate

  def populate(event)
    data = event.target.selected.data
    el = data[:id].to_class.new
    data[:proc].call el if data[:proc]
    data[:args].to_h.each do |key, value|
      if el.respond_to?("#{key}=")
        el.send("#{key}=", value)
      else
        el[key] = value
      end
    end
    oc = @container.demo_container.options
    oc.empty
    data[:options].to_h.each do |key, value|
      input = case value
              when :range
                RangeField.new
              when :input
                InputField.new
              when :checkbox
                CheckboxField.new
              end
      input.text = key
      input.value = el.send key
      input.on :change do
        el.send("#{key}=", input.value)
      end
      oc << input
    end
    request_animation_frame do
      @container.demo_container.demo.empty
      @container.demo_container.demo << el
    end
  end
end

CHOOSER_ITEMS = [
  { id: 'en', value: 'English' },
  { id: 'hu', value: 'Hungarian' },
  { id: 'fr', value: 'French' },
  { id: 'gr', value: 'German' }
]

Fron::Sheet.add_rule 'body', { margin: 0, fontSize: 16.px }, '0'

create_tabs = lambda do |tabs|
  (1..3).each do |index|
    el = UI::Tabs::Tab.new
    el[:tab] = "Tab #{index}"
    el.html = Lorem.paragraph
    tabs << el
  end
end

data = [
  { id: 'UI::Button', args: { text: 'Button...' }, options: { text: :input } },
  { id: 'UI::DatePicker' },
  { id: 'UI::ColorPicker', args: { value: '#328B3F' } },
  { id: 'UI::Checkbox', args: { checked: true } },
  { id: 'UI::Calendar' },
  { id: 'UI::ColorPanel' },
  { id: 'UI::Slider' },
  { id: 'UI::Chooser', args: { items: CHOOSER_ITEMS, placeholder: 'Choose language...' }, options: { disabled: :checkbox, multiple: :checkbox, placeholder: :input, searchable: :checkbox } },
  { id: 'UI::Loader', args: { loading: true } },
  { id: 'UI::Image', args: { src: 'http://m3.i.pbase.com/o6/90/547190/1/116543443.KT2b8KYm.IMG_9562.jpg', width: 800.px, height: 533.px } },
  { id: 'UI::Progress', args: { value: 0.1 } },
  { id: 'UI::Tabs', args: {}, proc: create_tabs },
  { id: 'UI::NumberRange', args: { affix: 'em', label: 'width:', min: 0, max: 10, step: 0.1 }, options: { affix: :input, label: :input, min: :range, max: :range, step: :range, round: :range } }
]

main = Main.new
main.container.sidebar.list.items = data
main.container.sidebar.list.select main.container.sidebar.list.children.last

DOM::Document.body << main
