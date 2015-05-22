module UI
  # A component for rendering a month calendar for a given date.
  #
  # It has the following features:
  # * Navigate to next / previous month
  # * Yields all the days (with their cells) for extended usage
  # * Displays the name of the rendered month (and year if it's not the same)
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Calendar < Base
    include UI::Behaviors::Actions
    extend Forwardable

    tag 'ui-calendar'

    component :header, UI::Container, direction: :row do
      component :icon,  UI::Icon,  glyph: 'caret-left',  clickable: true, action: :prev_month
      component :label, UI::Label, flex: 1
      component :icon,  UI::Icon,  glyph: 'caret-right', clickable: true, action: :next_month
    end

    component :table, :table do
      component :thead, :thead do
        component :tr, :tr
      end

      component :tbody, :tbody
    end

    def_delegators :table, :tbody, :thead
    def_delegators :header, :label

    style borderRadius: -> { theme.border_radius.em },
          padding: -> { (theme.spacing * 1.25).em },
          background: -> { colors.input },
          minWidth: 18.em,
          'ui-label' => { textAlign: :center,
                          fontWeight: 700 },
          'ui-icon' => { width: -> { (theme.spacing * 2).em } },
          'ui-container' => {
            borderBottomWidth: -> { (theme.border_size / 2).em },
            borderBottomColor: -> { colors.background },
            paddingBottom: -> { theme.spacing.em },
            borderBottomStyle: :solid
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

    # Initializes the calendar with todays date
    def initialize
      super
      render
    end

    # Renders the next month in the calendar
    def next_month
      render @date.next_month
    end

    # Renders the previous month in the calendar
    def prev_month
      render @date.prev_month
    end

    # Renders the calendar for the given date
    #
    # @param date [Date] The date
    def render(date = Date.today)
      @date = date
      label.text = date.strftime date.year == Date.today.year ? '%B' : '%B %Y'
      render_header
      render_body(date) do |*args|
        yield(*args) if block_given?
      end
    end

    private

    # Renders the table header with the shortnames
    def render_header
      thead.tr.empty
      Date.this_week.each do |day|
        thead.tr << DOM::Element.new("th #{day.strftime('%a')}")
      end
    end

    # Renders the table body with the days
    def render_body
      tbody.empty

      @date.days_for_calendar.each_slice(7) do |data|
        row = DOM::Element.new('tr')
        row >> tbody

        data.each do |day|
          td = Td.new(day)
          td >> row
          next if day.is_a?(String)
          yield day, td
        end
      end
    end

    # Cell for the calendar body
    class Td < Fron::Component
      # Initialize the cell with the day
      #
      # @param day [Date] The day
      def initialize(day)
        super nil
        return if day.is_a?(String)
        self[:date] = day
        self.text = day.day
      end
    end
  end
end
