module Examples
  class Contacts < UI::Container
    # List
    class List < UI::List
      include UI::Behaviors::SelectableChildren

      tag 'ui-list'
    end
  end
end
