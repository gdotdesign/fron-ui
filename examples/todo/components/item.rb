class Todos < UI::Box
  # Todo Item
  class Item < UI::Container
    include UI::Behaviors::Actions
    include UI::Behaviors::Remove

    extend Forwardable

    tag 'ui-item'

    def_delegators :span, :text=, :text
    def_delegators :checkbox, :checked, :checked=

    component :checkbox, UI::Checkbox
    component :span,     :span
    component :action,   UI::Action, action: :remove! do
      component :icon,     UI::Icon, glyph: :remove
    end

    style fontFamily: -> { theme.font_family },
          padding: -> { theme.spacing.em },
          color: -> { colors.font },
          'span' => {
            flex: 1
          },
          'ui-checkbox' => {
            height: 1.4.em,
            width: 1.4.em
          },
          '&.done span' => {
            textDecoration: 'line-through'
          }

    on :change, :render

    remove_confirmation 'Are you sure?'

    def render
      toggle_class :done, done?
    end

    alias_method :done?, :checked

    def data
      {
        done: done?,
        text: text
      }
    end
  end
end
