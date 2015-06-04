module UI
  module Behaviors
    module IntendableChildren
      # Sets up the behavior:
      #
      # * Sets styles for children
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.style '> .hidden' => { display: :none },
                   '> *:hover' => { background: -> { dampen colors.input, 0.05 } },
                   '> *.intended' => { background: -> { dampen colors.input, 0.1 } }
      end

      # Intends selection for the
      # next intendable item
      def intend_next
        intend_with :first, :next
      end

      # Intends selection for the
      # previous intendable item
      def intend_previous
        intend_with :last, :previous
      end

      # Intends an item
      #
      # @param tail [Symbol] First or last
      # @param method [Symbol] Next or previous
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

      # Intends the given item
      #
      # @param item [Fron::Component] The item
      def intend(item)
        return unless item
        intended.remove_class(:intended) if intended
        item.add_class(:intended)
      end

      # Returns the currently intended item
      #
      # @return [Fron::Component] The item
      def intended
        find('.intended')
      end

      # Returns the children that can be intended
      #
      # @return [Array<Fron::Component>] The items
      def intend_children
        children.select { |child| !child.has_class :hidden }
      end
    end
  end
end
