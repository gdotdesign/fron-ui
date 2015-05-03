class Todos < UI::Box
  # Options
  class Options < UI::Container
    # Behaviors
    include UI::Behaviors::SelectableChildren

    # Selectable elements
    component :all,       UI::Action, text: 'All',       value: :all
    component :active,    UI::Action, text: 'Active',    value: :active
    component :completed, UI::Action, text: 'Completed', value: :completed

    # Styles
    style '> *:not(.selected)' => { opacity: 0.4 },
          'ui-action:focus' => { opacity: 1 }

    # Select the first by default
    def initialize
      super
      select @all
    end
  end
end
