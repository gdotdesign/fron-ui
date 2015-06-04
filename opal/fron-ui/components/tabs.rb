module UI
  class Tabs < Base
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
            '&.selected' => { borderBottom: -> { "#{theme.border_size.em} solid #{colors.primary}" } },
            '&:focus' => { borderBottom: -> { "#{theme.border_size.em} solid #{colors.focus}" } },
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
            borderBottom: -> { "#{theme.border_size.em} solid #{dampen colors.background, 0.05}" }
    end

    class Tab < Base
      tag 'ui-tab'

      style padding: -> { theme.spacing.em }
    end

    tag 'ui-tabs'

    component :handles, Handles, base: Handle

    style '> *:not(ui-tab-handles):not(.active)' => { visibility: :hidden,
                                                      overflow: :hidden,
                                                      display: :block,
                                                      padding: 0,
                                                      height: 0 },
          '> .active' => { visibility: :visible,
                           overflow: :auto,
                           display: :block,
                           height: :auto }

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
      select find("[tab='#{handles.selected.tab_id}']")
    end

    def select(tab)
      return unless tab
      active_tab.remove_class(:active) if active_tab
      tab.add_class(:active)
    end

    def active_tab
      find('[tab].active')
    end

    def update_tabs
      return unless @handles
      handles.items = tabs.map { |item| { id: item[:tab], name: item[:tab] } }.uniq
      unless handles.selected
        handles.select_first
        select_tab
      end
    end

    def tabs
      find_all('[tab]')
    end
  end
end
