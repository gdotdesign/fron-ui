require 'fron-ui/components/box'
require 'fron-ui/components/input'

module UI
  class Dropdown < Box
    tag 'ui-dropdown[direction=column]'

    style display: :block,
          position: :absolute,
          boxShadow: '0 5px 10px -5px rgba(0,0,0,0.5)',
          background: -> { colors.background_lighter },
          border: -> { "#{(theme.border_size / 2).em} solid #{colors.border}" },
          marginTop: -> { (theme.spacing / 2).em },
          '&[position=bottom]' => {
            top: '100%'
          }

    def open
      show
    end

    def close
      hide
    end
  end

  class Calendar < Base
    tag 'ui-calendar'

    component :table, :table do
      component :thead, :thead do
        component :tr, :tr
      end
      component :tbody, :tbody
    end

    style table: { tableLayout: :fixed,
                   borderCollapse: :collapse,
                   'th' => {
                     fontSize: 0.8.em,
                     padding: -> { "#{theme.spacing.em} 0" },
                     opacity: 0.6
                   },
                   'td, th' => {
                     width: 2.em,
                     height: 2.em,
                     borderRadius: -> { theme.border_radius.em }
                   }
                 }

    def render(date)
      render_header
      render_cells(date) do |*args|
        yield(*args)
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
      (0...days.first.wday - 1).each do
        row << DOM::Element.new('td')
      end
      days.each do |day|
        if day.monday?
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

  class DatePicker < Base
    include UI::Behaviors::Actions

    attr_reader :value

    tag 'ui-date-picker'

    style 'ui-label' => { textAlign: :center,
                          fontWeight: 700 },
          'th, td' => { textAlign: :center },
          'td[date]' => { cursor: :pointer },
          'td.today' => {
            background: -> { colors.focus },
            color: -> { readable_color(colors.focus) },
            fontWeight: 600
          },
          'ui-container' => {
            borderBottomStyle: :solid,
            borderBottomWidth: -> { theme.border_size.em },
            borderBottomColor: -> { colors.border },
            paddingBottom: -> { theme.spacing.em }
          }

    component :input, UI::Input
    component :dropdown, UI::Dropdown do
      component :header, UI::Container, direction: :row do
        component :icon, UI::Icon, glyph: 'caret-left', clickable: true, action: :prev_month
        component :label, UI::Label, flex: 1
        component :icon, UI::Icon, glyph: 'caret-right', clickable: true, action: :next_month
      end

      component :calendar, UI::Calendar
    end

    on :click, 'td[date]', :select
    on :mousedown, 'ui-dropdown, ui-dropdown *', :stop
    on :change, 'input', :changed

    def initialize
      super
      @input.on :focus do @dropdown.open end
      @input.on :blur  do @dropdown.close end
      @date = Date.today
      self.value = Date.today
    end

    def value=(date)
      changed = @value != date
      @value = date
      render
      trigger :change if changed
    end

    def next_month
      @date = @date.next_month
      render
    end

    def prev_month
      @date = @date.prev_month
      render
    end

    def select(event)
      self.value = Date.parse(event.target[:date])
    end

    def stop(event)
      event.prevent_default
    end

    def changed
      @date = Date.parse(@input.value)
      self.value = @date
    rescue
      self.value = Date.today
      warn 'Wrong date input!'
    end

    def render
      @dropdown.header.label.text = @date.strftime '%B %Y'
      @input.value = @value.strftime
      @dropdown.calendar.render @date do |day, cell|
        cell.add_class 'today' if day == @value
      end
    end
  end
end
