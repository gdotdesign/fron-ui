require 'fron-ui/components/box'
require 'fron-ui/components/input'

module UI
  class DatePicker < Base
    attr_reader :value

    tag 'ui-date-picker'

    style 'table td[date]' => { cursor: :pointer,
                                background: -> { colors.background },
                                '&:hover' => { background: -> { colors.primary },
                                               color: -> { readable_color(colors.primary) },
                                               fontWeight: 600 } },
          'table td[date].selected' => {
            background: -> { colors.focus },
            color: -> { readable_color(colors.focus) },
            fontWeight: 600
          }

    component :input, UI::Input
    component :dropdown, UI::Dropdown do
      component :calendar, UI::Calendar
    end

    on :click, 'td[date]', :select
    on :change, 'input', :changed

    def initialize
      super
      @input.on(:focus) { @dropdown.open }
      @input.on(:blur)  { @dropdown.close }
      self.value = Date.today
    end

    def value=(date)
      changed = @value != date
      @value = date
      render
      trigger :change if changed
    end

    def select(event)
      self.value = Date.parse(event.target[:date])
    end

    def changed
      self.value = Date.parse(@input.value)
    rescue
      self.value = Date.today
      warn 'Wrong date input!'
    end

    def render
      @input.value = @value.strftime
      @dropdown.calendar.render @value do |day, cell|
        cell.add_class :selected if day == @value
      end
    end
  end
end
