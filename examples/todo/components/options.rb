# Todo List
class Todos < UI::Box
  # Options
  class Options < UI::Container
    include UI::Behaviors::SelectableChildren

    component :all, UI::Action, text: 'All', value: :all
    component :active, UI::Action, text: 'Active', value: :active
    component :completed, UI::Action, text: 'Completed', value: :completed

    style '> *:not(.selected)' => { opacity: 0.4 },
          'ui-action:focus' => { opacity: 1 }

    def initialize
      super
      select @all
    end
  end
end
