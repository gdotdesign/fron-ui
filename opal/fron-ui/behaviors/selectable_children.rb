module UI
  module Behaviors
    # Selectable Children
    module SelectableChildren
      def self.included(other)
        other.on :click, :on_select
        other.style '> *' => { cursor: :pointer }
      end

      def on_select(event)
        select children.find { |child| child.include?(event.target) }
      end

      def select(child)
        return unless child
        selected.remove_class :selected if selected
        child.add_class :selected
        trigger :selected_change
      end

      def selected
        children.find { |child| child.has_class :selected }
      end
    end
  end
end
