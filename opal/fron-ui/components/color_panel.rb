require 'fron-ui/components/container'
require 'fron-ui/components/drag'

require 'native'
require 'math'

class Color::RGB
  def css_rgba(alpha)
    alpha = format('%.1f', alpha)
    "rgba(#{red.round},#{green.round},#{blue.round},#{alpha})"
  end
end

module UI
  # Color selector component with a draggable field for
  # selecting the saturation / value and
  # a slider for selecting hue.
  #
  # @attr_reader [Integer] hue The hue of the represented color
  # @attr_reader [Integer] value The value of the represented color
  # @attr_reader [Integer] saturation The saturation of the represented color
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class ColorPanel < UI::Container
    extend Forwardable

    CHECKER = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3wkUCDAEK+8FsQAAADNJREFUKM9jPHPmDAM2YGxsjFWciYFEMKqBGMD4//9/rBJnz54d8p7G5TecGhgZGQfIDwBAQAuAAa2FpwAAAABJRU5ErkJggg=='

    tag 'ui-color-wheel[direction=column]'

    style borderRadius: -> { theme.border_radius.em },
          padding: -> { (theme.spacing * 2).em },
          background: -> { colors.input },
          'ui-drag' => { boxShadow: '0 0 1px 1px rgba(0,0,0,0.2) inset',
                         cursor: :pointer },
          '> ui-drag' => {
            backgroundPosition: :center,
            height: 1.2.em,
            'ui-drag-handle' => { transform: 'translateX(-50%)',
                                  borderRadius: 0.5.em,
                                  top: -0.25.em,
                                  bottom: -0.25.em,
                                  width: 0.5.em,
                                  height: 'auto' }
          },
          'ui-container' => {
            'ui-drag:first-of-type' => { backgroundImage: 'linear-gradient(0deg, #000 0%, transparent 100%),
                                                           linear-gradient(90deg, #fff 0%, rgba(255,255,255,0) 100%)',
                                         width: 14.em,
                                         height: 14.em },
            'ui-drag:last-of-type' => { backgroundImage: 'linear-gradient(to bottom, #ff0000 0%, #ffff00 17%, #00ff00 33%,
                                                                          #00ffff 50%, #0000ff 67%, #ff00ff 83%, #ff0000 100%)',
                                        width: 1.2.em,
                                        'ui-drag-handle' => { transform: 'translateY(-50%)',
                                                              borderRadius: 0.5.em,
                                                              right: -0.25.em,
                                                              left: -0.25.em,
                                                              height: 0.5.em,
                                                              width: 'auto' } }
          }

    component :container, UI::Container, direction: :row do
      component :recta, UI::Drag
      component :hued, UI::Drag, horizontal: false
    end
    component :alphad, UI::Drag, vertical: false

    on :change, 'ui-drag', :change
    on :mousedown, :stop

    def_delegators :container, :recta, :hued

    attr_reader :hue, :saturation, :value

    # Initializes the component with default
    # values for hue, value and saturation
    def initialize
      super

      @hue = 0
      @value = 100
      @saturation = 0
      @alpha = 0

      render
    end

    def stop(event)
      event.stop
    end

    # Handles changes from the fields, sets the
    # hue, value and saturation from on the fields.
    #
    # @param event [DOM::Event] The event
    def change(event)
      event.stop
      hue = hued.value_y * 360
      value = (1 - recta.value_y) * 100
      saturation = recta.value_x * 100
      alpha = @alphad.value_x * 100
      return if hue == @hue &&
                value == @value &&
                saturation == @saturation &&
                alpha == @alpha
      @hue = hue
      @value = value
      @saturation = saturation
      @alpha = alpha
      render
      trigger :change
    end

    # Sets the hue to the given value
    #
    # @param value [Integer] Integer between 0 and 360
    def hue=(value)
      @hue = value
      hued.value_y = value / 360
      render
    end

    # Sets the saturation to the given value
    #
    # @param value [Integer] Integer between 0 and 100
    def saturation=(value)
      @saturation = value
      recta.value_x = value / 100
      render
    end

    # Sets the value to the given value
    #
    # @param value [Integer] Integer between 0 and 100
    def value=(value)
      @value = value
      recta.value_y = (100 - value) / 100
      render
    end

    def alpha=(value)
      @alpha = value
      @alphad.value_x = value / 100
      render
    end

    def to_css
      if @alpha.round == 100
        '#' + color.hex.upcase
      else
        color.css_rgba(@alpha / 100)
      end
    end

    private

    # Returns the color
    #
    # :reek:UncommunicativeVariableName
    #
    # @return [Color::RGB] The color
    def color
      s = saturation / 100
      v = value / 100
      h = hue

      c = v * s
      x = c * (1 - ((h / 60).modulo(2) - 1).abs)
      m = v - c

      r, g, b = if (0...60).include?(h)
                  [c, x, 0]
                elsif (60...120).include?(h)
                  [x, c, 0]
                elsif (120...180).include?(h)
                  [0, c, x]
                elsif (180...240).include?(h)
                  [0, x, c]
                elsif (240...300).include?(h)
                  [x, 0, c]
                elsif (300..360).include?(h)
                  [c, 0, x]
                end

      Color::RGB.from_fraction(r + m, g + m, b + m)
    end

    # Sets the color from a string
    #
    # :reek:UncommunicativeVariableName
    #
    # @param color [String] The hex or CSS representation
    def color=(color)
      if (md = color.match(/rgba\((\d{1,3}),(\d{1,3}),(\d{1,3}),(\d+\.\d+)\)/))
        color = Color::RGB.new(md[1].to_i, md[2].to_i, md[3].to_i)
        alpha = md[4].to_f * 100
      else
        alpha = 100
      end
      color = Color::RGB.by_css(color) unless color.is_a? Color
      rgb = color.to_rgb.to_a
      r, g, b = rgb

      cmax = rgb.max
      cmin = rgb.min

      delta = cmax - cmin

      self.hue = if delta == 0
                   0
                 elsif cmax == r
                   60 * (((g - b) / delta).modulo(6))
                 elsif cmax == g
                   60 * (((b - r) / delta) + 2)
                 elsif cmax == b
                   60 * (((r - g) / delta) + 4)
                 end

      self.saturation = (cmax == 0 ? 0 : delta / cmax) * 100
      self.value = cmax * 100
      self.alpha = alpha
    end

    # Renders the component
    def render
      rgb = "#{color.red.round}, #{color.green.round}, #{color.blue.round}"
      alphad.style.background = "linear-gradient(90deg, rgba(#{rgb},0), rgba(#{rgb},1)), url(#{CHECKER})"
      recta.style.backgroundColor = "hsl(#{hue}, 100%, 50%)"
    end
  end
end
