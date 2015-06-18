require_relative 'item'
require_relative 'list'

module Examples
  class Contacts < UI::Container
    # Sidebar
    class Sidebar < UI::Box
      extend Forwardable

      tag 'ui-sidebar'

      component :title, UI::Title, text: 'Contacts'
      component :input, UI::Input, placeholder: 'Search...'
      component :list, List, empty_message: 'No contacts to display!', flex: 1, base: Item
      component :button, UI::Button, text: 'Add new contact!', action: :add

      def_delegators :list, :items, :items=, :selected, :deselect

      # Selects the item with the given id
      #
      # @param id [String] The ID
      def select(id)
        return @list.deselect if id.empty?
        @list.select @list.children.find { |item| item.data[:id] == id }
      end
    end
  end
end
