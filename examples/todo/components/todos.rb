# Todo List
class Todos < UI::Box
  # Includes
  include UI::Behaviors::Keydown
  include UI::Behaviors::Actions
  include UI::Behaviors::Render

  # Extends
  extend Forwardable

  # Tag definition
  tag 'ui-todos'

  # When pressing enter add a new item
  keydown :enter, :add

  # Styles
  style minHeight: 35.em,
        'ui-container:last-of-type' => {
          borderTop: -> { "#{theme.border_size.em} solid #{colors.border}" },
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
    component :options, Options, direction: :row
  end

  # Delegate storage to class
  def_delegators :class, :storage

  # Render on checkbox change
  on :refresh, :render
  # Render when filters change
  on :selected_change, :render

  # Set render method
  render :render!

  # Initializes the list
  def initialize
    super
    render
  end

  # Renders the component
  def render!
    items = storage.all.to_a
    render_items items
    done_count = items.count { |item| item[:done] }
    @footer.count.text = "#{items.count - done_count} items left"
  end

  # Render items based on the selected filter
  def render_items(items)
    @list.items = case @footer.options.selected.value
                  when :active
                    items.reject { |item| item[:done] }
                  when :completed
                    items.select { |item| item[:done] }
                  else
                    items
                  end.sort_by { |item| item[:text] }
  end

  # Adds a new item
  def add
    return if value.empty?
    id = SecureRandom.uuid
    storage.set id, text: value, done: false, id: id
    @header.input.value = ''
    render
  end

  private

  # Returns the value of the input field
  #
  # @return [String] The value
  def value
    @header.input.value.to_s.strip
  end

  # Returns the prefixed storage
  #
  # @return [Storage] The storage
  def self.storage
    @storage ||= Storage.new :todos
  end
end
