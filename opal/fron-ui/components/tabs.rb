module UI
  class Tabs < UI::Container
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

      def render
        self.tab_id = @data[:id]
        self.text = @data[:name]
      end
    end

    class Handles < Collection
      include UI::Behaviors::SelectableChildren

      tag 'ui-tab-handles'

      style display: :block,
            flex: '0 0 auto',
            borderBottom: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" }
    end

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

    def <<
      super
      update_tabs
    end

    def insert_before
      super
      update_tabs
    end

    def remove
      super
      update_tabs
    end

    def select_tab
      select find_by_id(handles.selected.tab_id)
    end

    def select(tab)
      return unless tab
      active_tab.remove_class(:active) if active_tab
      handles.select handles.find("[tab_id='#{tab[:tab]}']")
      tab.add_class(:active)
    end

    def active_tab
      find('[tab].active')
    end

    def find_by_id(id)
      find("[tab='#{id}']")
    end

    def update_tabs
      return unless @handles
      handles.items = tabs.map { |item| { id: item[:tab], name: item[:tab] } }.uniq
      return if handles.selected
      handles.select_first
      select_tab
    end

    def tabs
      find_all('[tab]')
    end
  end
end
