require 'fron-ui/components/input'
require 'fron-ui/components/icon'
require 'fron-ui/components/dropdown'
require 'fron-ui/components/calendar'

module UI
  # Component for selecting a date
  #
  # Features:
  # * Input field for manual input
  # * Dropdown with calendar for date selection
  # * Selected date is highlighted
  #
  # @attr_reader [Date] value The value of the component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class DatePicker < Base
    include UI::Behaviors::Keydown
    include UI::Behaviors::Dropdown
    extend Forwardable

    attr_reader :value

    tag 'ui-date-picker'

    style color: -> { readable_color colors.input },
          display: 'inline-block',
          position: :relative,
          '> ui-icon' => { width: -> { theme.size.em },
                           position: :absolute,
                           fontSize: 1.2.em,
                           bottom: 0,
                           right: 0,
                           top: 0 },
          input: { paddingRight: -> { (theme.size * 1.25).em },
                   boxSizing: 'border-box',
                   width: '100%' },
          'table td[date]' => { cursor: :pointer,
                                '&:hover' => { color: -> { readable_color(colors.primary) },
                                               background: -> { colors.primary },
                                               fontWeight: 600 } },
          'table td[date].selected' => { color: -> { readable_color(colors.focus) },
                                         background: -> { colors.focus },
                                         fontWeight: 600 }

    component :input, UI::Input
    component :icon,  UI::Icon, glyph: :calendar

    component :dropdown, UI::Dropdown do
      component :calendar, UI::Calendar
    end

    def_delegators :input, :active?, :focus, :blur

    on :click,  'td[date]', :select
    on :change, 'input',    :changed
    on :rendered, :render

    keydown :down, :next
    keydown :up,   :prev

    dropdown :input, :dropdown

    # Initialize the component by
    # setting the default value for today.
    def initialize
      super
      @input.on(:focus) { render }
      @dropdown.on :mousedown, &:prevent_default
      self.value = Date.today
    end

    # Selects the next date, if shift is down
    # it select the same date in the next month,
    #
    # @param event [DOM::Event] The event
    def next(event)
      self.value = if event.shift?
                     @value.next_month
                   else
                     @value + 1
                   end
    end

    # Selects the previous date, if shift is down
    # it select the same date in the previous month,
    #
    # @param event [DOM::Event] The event
    def prev(event)
      self.value = if event.shift?
                     @value.prev_month
                   else
                     @value - 1
                   end
    end

    # Sets the value of the field
    #
    # @param date [Date] The date
    def value=(date)
      date = parse_date(date)
      raise "Supplied value '#{date}' is not a date or cound't be coerced into one!" unless date.is_a?(Date)
      changed = @value != date
      @value = date
      @input.value = @value.strftime
      @dropdown.calendar.render @value
      trigger :change if changed
    end

    def parse_date(raw)
      Date.parse(raw)
    rescue
      raw
    end

    # Selects the clicked td
    #
    # @param event [DOM::Event] The event
    def select(event)
      self.value = Date.parse(event.target[:date])
    end

    # Updates the value after the change
    # of the input, if it's a wrong date
    # it sets it for today.
    def changed
      self.value = Date.parse(@input.value)
    rescue
      self.value = Date.today
      warn 'Wrong date input!'
    end

    # Renders the component
    def render
      cell = @dropdown.find("td[date='#{value}']")
      return unless cell
      cell.add_class :selected
    end
  end
end
