module UI
  class Calendar < Base
    include UI::Behaviors::Actions

    tag 'ui-calendar'

    component :header, UI::Container, direction: :row do
      component :icon, UI::Icon, glyph: 'caret-left', clickable: true, action: :prev_month
      component :label, UI::Label, flex: 1
      component :icon, UI::Icon, glyph: 'caret-right', clickable: true, action: :next_month
    end

    component :table, :table do
      component :thead, :thead do
        component :tr, :tr
      end
      component :tbody, :tbody
    end

    style minWidth: 18.em,
          'ui-label' => { textAlign: :center,
                          fontWeight: 700 },
          'ui-icon' => { width: -> { (theme.spacing * 2).em } },
          'ui-container' => {
            borderBottomStyle: :solid,
            borderBottomWidth: -> { (theme.border_size / 2).em },
            borderBottomColor: -> { colors.background },
            paddingBottom: -> { theme.spacing.em }
          },
          table: { borderSpacing: 0.4.em,
                   'td[date]' => { background: -> { colors.background_lighter },
                                   color: -> { colors.font } },
                   'th' => {
                     fontSize: 0.8.em,
                     padding: -> { "#{theme.spacing.em} 0" },
                     opacity: 0.6
                   },
                   'td, th' => {
                     textAlign: :center,
                     width: 2.em,
                     height: 2.em,
                     borderRadius: -> { theme.border_radius.em }
                   }
                 }

    def initialize
      super
      render Date.today
    end

    def next_month
      render @date.next_month
    end

    def prev_month
      render @date.prev_month
    end

    def render(date)
      @date = date if date
      @header.label.text = date.strftime date.year == Date.today.year ? '%B' : '%B %Y'
      render_header
      render_cells(date) do |*args|
        yield(*args) if block_given?
      end
    end

    def render_header
      @table.thead.tr.empty
      Date.this_week.each do |day|
        @table.thead.tr << DOM::Element.new("th #{day.strftime('%a')}")
      end
    end

    def render_cells(date)
      @table.tbody.empty
      days = (date.beginning_of_month..date.end_of_month).to_a
      row = DOM::Element.new('tr')
      range = days.first.wday == 0 ? (0..5) : (0...days.first.wday - 1)
      range.each do
        row << DOM::Element.new('td')
      end
      days.each do |day|
        if row.children.count == 7
          @table.tbody << row
          row = DOM::Element.new('tr')
        end
        td = DOM::Element.new("td[date=#{day}] #{day.day}")
        row << td
        yield day, td
      end
      @table.tbody << row
    end
  end
end
