require 'fron-ui/components/dropdown'
require 'fron-ui/components/input'

module UI
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
            '> .hidden' => { display: :none },
            '> *:hover' => { background: -> { colors.background_lighter } },
            '> *.intended' => { background: -> { colors.background } },
            '> *.selected' => { background: -> { colors.primary },
                                color: -> { readable_color colors.primary } }
      def intend_next
        intend_with :first, :next
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
        children.select(&:visible?)
      end
    end

    include UI::Behaviors::Dropdown
    extend Forwardable

    attr_reader :items

    tag 'ui-chooser'

    component :input, UI::Input
    component :dropdown, UI::Dropdown do
      component :list, List, base: Item
    end

    dropdown :input, :dropdown

    def_delegators :input, :placeholder, :placeholder=
    def_delegators :list, :base, :base=, :key, :key=, :multiple, :multiple=
    def_delegators :dropdown, :list

    style position: :relative,
          'ui-dropdown' => { left: 0,
                             right: 0 }

    on :keydown, :keydown
    on :input,   :filter
    on :selected_change, :selected_changed

    def searchable=(value)
      @input.readonly = !value
    end

    def searchable
      !@input.readonly
    end

    def initialize
      super
      @input.on(:focus) { empty_input }
      @input.on(:blur) { update_input }
    end

    def items=(items)
      list.items = items
      filter
    end

    def empty_input
      return if @input.readonly
      @input.value = ''
    end

    def selected_changed
      return if searchable
      update_input
    end

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

    def show_items
      list.children.each { |item| item.remove_class :hidden }
    end

    def filter
      list.children.each do |item|
        item.toggle_class :hidden, !(item.value =~ Regexp.new(@input.value, 'i'))
      end
    end

    def keydown(event)
      return unless [:enter, :esc, :up, :down].include?(event.key)
      event.prevent_default
      event.stop_propagation
      case event.key
      when :enter
        list.select list.intended
      when :esc
        @input.blur
      when :up
        list.intend_previous
      when :down
        list.intend_next
      end
    end
  end
end
