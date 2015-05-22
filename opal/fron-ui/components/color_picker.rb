require 'fron-ui/components/input'
require 'fron-ui/components/dropdown'
require 'fron-ui/components/color_panel'

module UI
  class ColorPicker < Base
    include UI::Behaviors::Dropdown

    extend Forwardable

    tag 'ui-color-picker'

    component :input, UI::Input, spellcheck: false
    component :div, 'div'

    component :dropdown, UI::Dropdown do
      component :color, UI::ColorPanel
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

    def_delegators :input, :value

    dropdown :input, :dropdown

    def initialize
      super
      @input.on(:focus) { update_dropdown }
      @input.value = '#FFFFFF'
    end

    def value=(value)
      @input.value = value
    end

    def update(event)
      update_dropdown
      event.stop
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
end
