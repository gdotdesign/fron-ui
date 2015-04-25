# Todo List
class Todos < UI::Box
  include UI::Behaviors::Keydown
  include UI::Behaviors::Actions
  include UI::Behaviors::Render

  tag 'ui-todos'

  keydown [:enter], :add

  style minHeight: 500.px,
        'ui-container:last-of-type' => {
          borderTop: -> { "#{(UI::Config.border_size * 1.5).em} solid #{UI::Config.colors.border}" },
          paddingTop: -> { UI::Config.spacing.em }
        }

  component :title, UI::Title, text: 'Todos', align: :center

  component :header, UI::Container do
    component :input, UI::Input, placeholder: 'Add Item...', flex: 1
    component :button, UI::Button, shape: :square, action: :add do
      component :icon, UI::Icon, glyph: :plus
    end
  end

  component :list, UI::List, flex: 1, empty_message: 'No items to display!'

  component :footer, UI::Container do
    component :count, UI::Label, flex: 1
    component :options, Options
  end

  on :change, :render
  on :domchange, :render
  on :selected_change, :render

  render :render!

  def initialize
    super
    load
    render
  end

  def load
    items = storage.get :items
    items.each do |data|
      add_item data[:text], data[:done]
    end
  end

  def save
    storage.set :items, items.map(&:data)
  end

  def render!
    @footer.count.text = "#{count - done_count} items left"
    items.each(&:show)
    case @footer.options.selected.value
    when :active
      items.select(&:done?)
    when :completed
      items.reject(&:done?)
    else
      []
    end.each(&:hide)
    @list.render
    save
  end

  def add_item(text, checked = false)
    item = Item.new
    item.text = text
    item.checked = checked
    item.render
    item >> @list
  end

  def add
    return if @header.input.value.to_s.strip.empty?
    add_item @header.input.value
    @header.input.value = ''
    render
  end

  private

  def done_count
    items.count(&:done?)
  end

  def count
    items.count
  end

  def items
    @list.children
  end

  def storage
    Fron::Storage::LocalStorage
  end
end
