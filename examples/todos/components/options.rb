class Todos < UI::Box
  # Filters
  class Filters < UI::Container
    tag 'ui-todo-filters'

    # Behaviors
    include UI::Behaviors::SelectableChildren

    # Selectable elements
    component :all,       UI::Action, text: 'All',       value: :all
    component :active,    UI::Action, text: 'Active',    value: :active
    component :completed, UI::Action, text: 'Completed', value: :completed

    # Styles
    style '> *' => { color: -> { dampen colors.font, 0.5 } },
          '.selected' => { color: -> { colors.font } }

    # Select the first by default
    def initialize
      super
      select @all
    end
  end
end
