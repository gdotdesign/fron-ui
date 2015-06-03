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
    class Item < Fron::Component
      include ::Record

      tag 'ui-chooser-item'

      style display: :block,
            padding: -> { (theme.spacing / 2).em }

      def render
        self.text = @data[:value]
      end

      def value
        text
      end
    end

    class List < Collection
      include UI::Behaviors::SelectableChildren

      tag 'ui-chooser-list'

      style background: -> { colors.input },
            borderRadius: -> { theme.border_radius.em },
            overflow: :auto,
            '> .hidden' => { display: :none },
            '> *:hover' => { background: -> { colors.background_lighter } },
            '> *.intended' => { background: -> { colors.background } },
            '> *.selected' => { background: -> { colors.primary },
                                color: -> { readable_color colors.primary } }
      def intend_next
        intend_with :first, :next
      end

      def select_intended
        select intended
      end

      def intend_previous
        intend_with :last, :previous
      end

      def intend_with(tail, method)
        children = intend_children
        index = children.index(intended)
        next_indenteded = begin
                            case method
                            when :next
                              children[index + 1]
                            when :previous
                              children[index - 1]
                            end
                          rescue
                            nil
                          end
        intend next_indenteded || intend_children.send(tail)
      end

      def intend(item)
        return unless item
        intended.remove_class(:intended) if intended
        item.add_class(:intended)
      end

      def intended
        find('.intended')
      end

      def intend_children
        children.select { |child| !child.has_class :hidden }
      end
    end

    include UI::Behaviors::Dropdown
    include UI::Behaviors::Keydown
    extend Forwardable

    attr_reader :items

    tag 'ui-chooser'

    component :input, UI::Input
    component :dropdown, UI::Dropdown do
      component :list, List, base: Item
    end

    dropdown :input, :dropdown

    def_delegators :input, :placeholder, :placeholder=, :blur
    def_delegators :list, :base, :base=, :key, :key=, :multiple, :multiple=,
                   :intend_next, :intend_previous, :select_intended
    def_delegators :dropdown, :list

    style position: :relative,
          input: { cursor: :pointer,
                   '&:not(:focus), &[readonly]' => { textOverflow: :ellipsis,
                                                     userSelect: :none,
                                                     overflow: :hidden } },
          'ui-dropdown' => { left: 0,
                             right: 0 }

    keydown :esc,  :blur
    keydown :up,   :intend_previous
    keydown :down, :intend_next
    keydown [:enter, :space], :select_intended

    on :input,   :filter
    on :selected_change, :selected_changed

    # Initilaizes the component, setting
    # up not bubbling events on the input
    def initialize
      super
      @input.on(:focus) { empty_input }
      @input.on(:blur) { update_input }
    end

    # Sets the searchable value, by setting
    # the inputs to read only attribute.
    #
    # @param value [Boolean] The value
    def searchable=(value)
      @input.readonly = !value
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
      @input.value = if list.selected && list.selected.is_a?(Array)
                       list.selected.map(&:value).join(', ')
                     elsif list.selected
                       list.selected.value
                     else
                       ''
                     end
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
  end
end
