module UI
  # Component for tabular UI.
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Tabs < UI::Container
    # Component for the handle.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    class Handle < Action
      include ::Record

      tag 'ui-tab-handle'

      attribute_accessor :tab_id

      style padding: -> { theme.spacing.em },
            top: -> { theme.border_size.em },
            display: 'inline-block',
            position: :relative,
            fontWeight: 600,
            opacity: 0.5,
            '&.selected' => { borderBottom: -> { "#{theme.border_size.em} solid #{colors.primary}" },
                              color: -> { colors.primary } },
            '&:focus' => { borderBottom: -> { "#{theme.border_size.em} solid #{colors.focus}" },
                           color: -> { colors.focus } },
            '&:hover, &.selected, &:focus' => { opacity: 1 }

      # Renders the component
      def render
        self.tab_id = @data[:id]
        self.text = @data[:name]
      end
    end

    # Tab handle container.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    class Handles < Collection
      include UI::Behaviors::SelectableChildren

      tag 'ui-tab-handles'

      style display: :block,
            flex: '0 0 auto',
            borderBottom: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" }
    end

    # Basic tab container.
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    class Tab < Base
      tag 'ui-tab'

      style padding: -> { theme.spacing.em }
    end

    extend Forwardable

    tag 'ui-tabs'

    component :handles, Handles, base: Handle

    def_delegators :handles, :base

    style '> *:not(ui-tab-handles):not(.active)' => { visibility: :hidden,
                                                      overflow: :hidden,
                                                      display: :block,
                                                      padding: 0,
                                                      height: 0 },
          '> .active' => { visibility: :visible,
                           overflow: :auto,
                           display: :block,
                           height: :auto,
                           flex: 1 }

    on :selected_change, :select_tab

    # Monkeypatch to update tabs
    def <<
      super
      update_tabs
    end

    # Monkeypatch to update tabs
    def insert_before
      super
      update_tabs
    end

    # Monkeypatch to update tabs
    def remove
      super
      update_tabs
    end

    # Activates the currently selected tab
    def select_tab
      select find_by_id(handles.selected.tab_id)
    end

    # Selects the given tab.
    #
    # @param tab [UI::Tabs::Tab, Fron::Component] The tab
    def select(tab)
      return unless tab
      active_tab.remove_class(:active) if active_tab
      handles.select handles.find("[tab_id='#{tab[:tab]}']")
      tab.add_class(:active)
    end

    # Returns the active tab
    #
    # @return [UI::Tabs::Tab, Fron::Component] The tab
    def active_tab
      find('[tab].active')
    end

    # Returns the tab by the given id
    #
    # @param id [String] The id
    #
    # @return [UI::Tabs::Tab, Fron::Component] The tab
    def find_by_id(id)
      find("[tab='#{id}']")
    end

    # Updates tab handles to reflect the content.
    def update_tabs
      return unless @handles
      handles.items = tabs.map { |item| { id: item[:tab], name: item[:tab] } }.uniq
      return if handles.selected || handles.children.empty?
      handles.select_first
      select_tab
    end

    # Returns all tabs
    #
    # @return [Array<UI::Tabs::Tab>] The tabs
    def tabs
      find_all('[tab]')
    end
  end
end
