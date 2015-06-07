class Todos < UI::Box
  # Filters
  class Filters < UI::Container
    # Behaviors
    include UI::Behaviors::SelectableChildren

    tag 'ui-todo-filters'

    # Selectable elements
    component :all,       UI::Action, text: 'All',       value: :all
    component :active,    UI::Action, text: 'Active',    value: :active
    component :completed, UI::Action, text: 'Completed', value: :completed

    # Styles
    style '> *' => { color: -> { dampen colors.background, 0.3 } },
          '.selected' => { color: -> { readable_color colors.background } }

    # Select the first by default
    def initialize
      super
      select @all
    end
  end
end
