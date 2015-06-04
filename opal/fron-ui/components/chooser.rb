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
        self.text = @data[:value]
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
                                color: -> { readable_color colors.primary } }

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
      component :list, List, base: Item
    end

    dropdown :input, :dropdown

    def_delegators :dropdown, :list
    def_delegators :input, :placeholder, :placeholder=, :blur
    def_delegators :list, :base, :base=, :key, :key=, :multiple, :multiple=,
                   :intend_next, :intend_previous, :select_intended, :items,
                   :select_first, :select_last

    style position: :relative,
          input: { cursor: :pointer },
          'ui-dropdown' => { left: 0,
                             right: 0 },
          '&:not([focused]):after,
           &:not([searchable]):after' => { background: -> { "linear-gradient(90deg, transparent, #{colors.input} 70%)" },
                                           position: :absolute,
                                           content: '""',
                                           width: 4.em,
                                           bottom: 0,
                                           right: 0,
                                           top: 0 }

    keydown :esc,  :blur
    keydown :up,   :intend_previous
    keydown :down, :intend_next
    keydown [:enter, :space], :select_intended

    on :input, :filter
    on :selected_change, :selected_changed

    # Initilaizes the component, setting
    # up not bubbling events on the input
    def initialize
      super
      self.searchable = true
      @input.on(:focus) do
        self[:focused] = ''
        empty_input
      end
      @input.on(:blur) do
        remove_attribute :focused
        update_input
      end
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
      list.items = items
      filter
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
    end

    # Updates the input text with
    # the selected items values
    def update_input
      timeout(320) { show_items }
      @input.value = Array(value).join(', ')
    end

    # Shows the items
    def show_items
      list.children.each { |item| item.remove_class :hidden }
    end

    # Filters the items by the input value
    def filter
      list.children.each do |item|
        item.toggle_class :hidden, !(item.value =~ Regexp.new(@input.value, 'i'))
      end
    end

    # Returns the value
    #
    # @return The value
    def value
      selected = list.selected
      if selected.is_a?(Array)
        return nil if selected.empty?
        selected.map(&:value)
      else
        selected.value
      end
    end
  end
end
