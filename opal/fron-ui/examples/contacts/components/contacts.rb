require_relative 'details'
require_relative 'sidebar'

module Examples
  # Contacts example
  class Contacts < UI::Container
    include UI::Behaviors::Actions
    include UI::Behaviors::Render
    include UI::Behaviors::Rest
    include UI::Behaviors::State

    extend Forwardable

    rest url: 'http://localhost:3000/contacts'

    component :sidebar, Sidebar, flex: '0 0 20em'
    component :details, Details, flex: 1

    style fontSize: 14.px,
          width: 67.5.em,
          margin: '0 auto',
          height: 57.5.em,
          padding: -> { theme.spacing.em },
          boxSizing: 'border-box'

    render :render!

    def_delegators :class, :storage

    on :selected_change, :select
    on :input, 'ui-sidebar input', :render
    on :refresh, :refresh
    on :destroyed, :destroyed

    state_changed :state_changed

    # Initializes the component
    def initialize
      super
      @items = []
      self[:direction] = :row
    end

    # Handles state change
    def state_changed
      load state
      render!
    end

    # Adds a new contact
    def add
      data = {
        id: SecureRandom.uuid
      }

      create data do |item|
        refresh do
          @sidebar.input.value = ''
          render!
          self.state = item[:id]
        end
      end
    end

    # Handles item selection from the list
    def select
      self.state = @sidebar.selected.data[:id]
    end

    # Loads the contact with the given id
    #
    # @param id [String] The ID
    def load(id)
      @details.load id
      render!
    end

    # Handles the destroyed event
    #
    # @param event [DOM::Event] The event
    def destroyed(event)
      self.state = nil if event.target.data[:id] == state
      refresh
    end

    # Refreshes the list
    def refresh
      all do |items|
        @items = items
        render { yield if block_given? }
      end
    end

    # Renders the list
    def render!
      @sidebar.items = @items.select { |item| item[:name].to_s.match Regexp.new(@sidebar.input.value || '.*', 'i') }
      @sidebar.select state
    end
  end
end
