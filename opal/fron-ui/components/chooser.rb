require 'fron-ui/components/dropdown'
require 'fron-ui/components/input'

module UI
  # Chooser component
  #
  # Features
  # * Select an item from the dropdown
  # * Allows multiple selection (multiple attribute)
  # * Search the items from the input
  # * Navigate / select with keyboard
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Chooser < Base
    # Item for the chooser
    class Item < Fron::Component
      include ::Record

      tag 'ui-chooser-item'

      style display: :block,
            padding: -> { (theme.spacing / 2).em }

      # Renders the item
      def render
        self.text = label
      end

      def label
        @data[:value]
      end

      # Retunrs the value
      #
      # @return [String] The value
      def value
        text
      end
    end

    # List for the chooser
    class List < Collection
      include UI::Behaviors::SelectableChildren
      include UI::Behaviors::IntendableChildren

      tag 'ui-chooser-list'

      style background: -> { colors.input },
            borderRadius: -> { theme.border_radius.em },
            color: -> { readable_color colors.input },
            overflow: :auto,
            '> *.selected' => { background: -> { colors.primary },
                                color: -> { readable_color colors.primary },
                                '&:first-child' => { borderTopLeftRadius: :inherit,
                                                     borderTopRightRadius: :inherit },
                                '&:last-child' => { borderBottomLeftRadius: :inherit,
                                                    borderBottomRightRadius: :inherit } }

      # Selects the currently intended item
      def select_intended
        select intended
      end
    end

    include UI::Behaviors::Dropdown
    include UI::Behaviors::Keydown
    extend Forwardable

    tag 'ui-chooser'

    component :input, UI::Input
    component :dropdown, UI::Dropdown do
      component :list, List, base: Item, deselectable: true
    end

    dropdown :input, :dropdown

    def_delegators :dropdown, :list
    def_delegators :input, :placeholder, :placeholder=, :blur, :active?, :focus
    def_delegators :list, :base, :base=, :key, :key=, :multiple, :multiple=,
                   :intend_next, :intend_previous, :select_intended, :items,
                   :select_first, :select_last, :deselectable, :deselectable=

    style position: :relative,
          color: -> { readable_color colors.input },
          input: { cursor: :pointer,
                   width: '100%' },
          'ui-dropdown' => { left: 0,
                             right: 0,
                             maxHeight: 300.px,
                             overflowY: :auto },
          '&:not([focused]):after,
           &:not([searchable]):after' => { background: -> { "linear-gradient(90deg, #{rgba(colors.input, 0)}, #{colors.input} 70%)" },
                                           borderBottomRightRadius: :inherit,
                                           borderTopRightRadius: :inherit,
                                           pointerEvents: :none,
                                           position: :absolute,
                                           content: '""',
                                           width: 4.em,
                                           bottom: 0.15.em,
                                           right: 0.15.em,
                                           top: 0.15.em },
          '&:before' => { borderStyle: :solid,
                          position: :absolute,
                          marginTop: -0.2.em,
                          content: "''",
                          opacity: 0.5,
                          top: '50%',
                          height: 0,
                          pointerEvents: :none,
                          width: 0,
                          borderColor: 'currentColor transparent transparent transparent',
                          borderWidth: '0.4em 0.35em 0 0.35em',
                          right: 0.75.em,
                          zIndex: 1 }

    keydown :esc,  :blur
    keydown :up,   :intend_previous
    keydown :down, :intend_next

    on :input, :filter
    on :selected_change, :selected_changed
    on :keydown, :keydown

    # Initilaizes the component, setting
    # up not bubbling events on the input
    def initialize
      super
      @dropdown.on :mousedown, &:prevent_default

      self.searchable = true
      @input.on(:focus) do
        self[:focused] = ''
        show_items
        empty_input
      end
      @input.on(:blur) do
        remove_attribute :focused
        update_input
      end
    end

    def keydown(event)
      return unless [:space, :enter].include?(event.key)
      result = select_intended
      event.stop if result
    end

    # Sets the searchable value, by setting
    # the inputs to read only attribute.
    #
    # @param value [Boolean] The value
    def searchable=(value)
      @input.readonly = !value
      if @input.readonly
        remove_attribute :searchable
      else
        self[:searchable] = ''
      end
    end

    # Returns if the component is searchable or not
    #
    # @return [Boolean] The value
    def searchable
      !@input.readonly
    end

    # Sets the items
    #
    # @param items [Array<Hash>] The items
    def items=(items)
      items = items.each_with_index.map { |item, index| { id: index, value: item } } unless items[0].is_a?(Hash)
      list.items = items
      update_input
    end

    # Empties the input
    def empty_input
      return if @input.readonly
      @input.value = ''
    end

    # Updates the input after
    # an item has been selected
    def selected_changed
      return if searchable
      update_input
      trigger :change
      @input.blur unless multiple
    end

    # Updates the input text with
    # the selected items values
    def update_input
      timeout(320) { show_items }
      return if searchable && DOM::Document.active_element == @input
      @input.value = Array(label).join(', ')
    end

    # Shows the items
    def show_items
      list.children.each { |item| item.remove_class :hidden }
    end

    # Filters the items by the input label
    def filter
      regexp = Regexp.new(@input.value.to_s, 'i')
      list.children.each do |item|
        item.toggle_class :hidden, !(item.label =~ regexp)
      end
    end

    # Returns the value
    #
    # @return The value
    def value
      selected_items(:value)
    end

    def selected_items(property)
      selected = list.selected
      return nil unless selected
      if selected.is_a?(Array)
        return nil if selected.empty?
        selected.map { |item| item.send(property) }
      else
        selected.send(property)
      end
    end

    def label
      selected_items(:label)
    end

    def value=(new_value)
      return if attribute?(:focused)
      values = Array(new_value)
      return if Array(value) == values
      list.deselect
      values.each do |val|
        list.select list.children.find { |child| child.value == val }
      end
      update_input
    end
  end
end
