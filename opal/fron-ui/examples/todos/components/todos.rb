require_relative 'item'
require_relative 'options'

# Todo List
class Todos < UI::Box
  # Includes
  include UI::Behaviors::Keydown
  include UI::Behaviors::Actions
  include UI::Behaviors::Render
  include UI::Behaviors::Rest

  # Extends
  extend Forwardable

  rest url: 'http://localhost:3000/todos'

  # Tag definition
  tag 'ui-todos'

  # When pressing enter add a new item
  keydown :enter, :add

  # Styles
  style minHeight: 35.em,
        'ui-container:last-of-type' => {
          borderTop: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" },
          paddingTop: -> { theme.spacing.em },
          fontWeight: '600'
        }

  # Component definitions
  component :title, UI::Title, text: 'Todos', align: :center

  component :header, UI::Container, direction: :row do
    component :input, UI::Input, placeholder: 'Add Item...', flex: 1
    component :button, UI::Button, shape: :square, action: :add do
      component :icon, UI::Icon, glyph: :plus
    end
  end

  component :list, UI::List, flex: 1, empty_message: 'No items to display!', base: Item

  component :footer, UI::Container, direction: :row do
    component :count, UI::Label, flex: 1
    component :filters, Filters, direction: :row
  end

  # Render on checkbox change
  on :refresh, :refresh
  # Render when filters change
  on :selected_change, :render

  # Set render method
  render :render!

  def initialize
    super
    DOM::Window.on('popstate') do
      @footer.filters.select @footer.filters.children.find { |item| item.value == get_state[:filter] }
    end
  end

  # Loads the items from the server
  def refresh
    all do |items|
      @items = items
      render
    end
  end

  # Renders the component
  def render!
    render_items
    done_count = @items.count { |item| item[:done] }
    @footer.count.text = "#{@items.count - done_count} items left"
    save_state
  end

  def get_state
    State.decode(`location.search`[1..-1])
  end

  def save_state
    return if get_state == state
    DOM::Window.state = '?' + State.encode(state)
  end

  def state
    { filter: @footer.filters.selected.value }
  end

  # Render items based on the selected filter
  def render_items
    @list.items = case @footer.filters.selected.value
                  when :active
                    @items.reject { |item| item[:done] }
                  when :completed
                    @items.select { |item| item[:done] }
                  else
                    @items
                  end.sort_by { |item| item[:text].to_s }
  end

  # Adds a new item
  def add
    return if value.empty?
    data = {
      id: SecureRandom.uuid,
      text: value,
      done: false
    }
    create data do
      @header.input.value = ''
      refresh
    end
    trigger :notification, message: 'Item added!'
  end

  private

  # Returns the value of the input field
  #
  # @return [String] The value
  def value
    @header.input.value.to_s.strip
  end
end
