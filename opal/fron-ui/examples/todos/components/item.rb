module Examples
  class Todos < UI::Box
    # Todo Item
    class Item < UI::Container
      # Includes
      include UI::Behaviors::Confirmation
      include UI::Behaviors::Actions
      include UI::Behaviors::Rest
      include ::Record

      rest url: 'http://localhost:3000/todos'

      # Extends
      extend Forwardable

      # Tag
      tag 'ui-todo-item'

      # Delegators
      def_delegators :span, :text=, :text
      def_delegators :checkbox, :checked, :checked=

      # Components
      component :checkbox, UI::Checkbox
      component :span, UI::Label, flex: 1
      component :action, UI::Action, action: :confirm_destroy! do
        component :icon, UI::Icon, glyph: 'android-close'
      end

      # Styles
      style fontFamily: -> { theme.font_family },
            padding: -> { theme.spacing.em },
            'ui-checkbox, ui-action' => {
              height: 1.5.em,
              width: 1.5.em
            },
            'ui-action' => {
              justifyContent: :center,
              alignItems: :center,
              display: :flex
            },
            '&.done ui-label' => {
              textDecoration: 'line-through'
            }

      on :change, :update!

      confirmation :destroy!, 'Are you sure?'

      # Initializes the component
      def initialize
        super
        self[:direction] = :row
      end

      # Destroys the element in the storage
      # and trigger refresh.
      def destroy!
        destroy do
          trigger :refresh
        end
      end

      # Updates the elemen tin the storage
      # and triggers refresh.
      def update!
        update done: done? do
          trigger :refresh
        end
      end

      # Renders the element
      def render
        self.checked = data[:done]
        self.text = data[:text]
        toggle_class :done, done?
      end

      # @!method done?
      #   Returns true if the item is in done state false if not
      alias_method :done?, :checked
    end
  end
end
