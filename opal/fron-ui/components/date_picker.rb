require 'fron-ui/components/input'
require 'fron-ui/components/icon'
require 'fron-ui/components/dropdown'
require 'fron-ui/components/calendar'

module UI
  class ColorPicker < Base
    tag 'ui-color-picker'

    component :input, UI::Input
    component :div, 'div'

    component :dropdown, UI::Dropdown do
      component :color, UI::ColorWheel
    end

    style position: :relative,
          display: 'inline-block',
          div: {
            position: :absolute,
            top: 0.3.em,
            right: 0.3.em,
            bottom: 0.3.em,
            width: 2.em,
            boxShadow: '0 0 1px 1px rgba(0,0,0,0.2) inset',
            pointerEvents: :none,
            borderRadius: -> { theme.border_radius.em }
          },
          input: {
            boxSizing: 'border-box',
            width: '100%',
            paddingRight: -> { (theme.size * 1.25).em }
          }

    on :change, :input, :update
    on :change, 'ui-color-wheel', :update_input

    def initialize
      super
      @input.on(:blur)  { @dropdown.close }
      @input.on(:focus) do
        @dropdown.open
        update_dropdown
      end
      @input.value = '#FFFFFF'
    end

    def value=(value)
      @input.value = value
      update_dropdown
    end

    def update(event)
      event.stop
      update_dropdown
    end

    def update_dropdown
      @dropdown.color.color = @input.value
    rescue
      update_input
    ensure
      render
    end

    def update_input
      @input.value = '#' + @dropdown.color.color.hex.upcase
      render
    end

    def render
      @div.style.background = '#' + @dropdown.color.color.hex.upcase
    end
  end

  class DatePicker < Base
    include UI::Behaviors::Keydown
    attr_reader :value

    tag 'ui-date-picker'

    style position: :relative,
          display: 'inline-block',
          '> ui-icon' => {
            position: :absolute,
            top: 0,
            right: 0,
            bottom: 0,
            width: -> { theme.size.em }
          },
          input: {
            boxSizing: 'border-box',
            width: '100%',
            paddingRight: -> { (theme.size * 1.25).em }
          },
          'table td[date]' => { cursor: :pointer,
                                '&:hover' => { background: -> { colors.primary },
                                               color: -> { readable_color(colors.primary) },
                                               fontWeight: 600 } },
          'table td[date].selected' => {
            background: -> { colors.focus },
            color: -> { readable_color(colors.focus) },
            fontWeight: 600
          }

    component :input, UI::Input
    component :icon, UI::Icon, glyph: :calendar
    component :dropdown, UI::Dropdown do
      component :calendar, UI::Calendar
    end

    on :click, 'td[date]', :select
    on :change, 'input', :changed

    keydown :down, :next
    keydown :up,   :prev

    def next(event)
      if event.shift?
        self.value = @value.next_month
      else
        self.value = @value + 1
      end
    end

    def prev(event)
      if event.shift?
        self.value = @value.prev_month
      else
        self.value = @value - 1
      end
    end

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
