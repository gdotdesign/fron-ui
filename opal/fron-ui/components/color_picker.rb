require 'fron-ui/components/input'
require 'fron-ui/components/dropdown'
require 'fron-ui/components/color_panel'

module UI
  # Component for selecting colors by a color picker
  # or just typing.
  #
  # Features:
  # * Typing a CSS color (hex or named) and
  #   pressing enter will update the color panel.
  # * Has a rectange for showing the selected color.
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class ColorPicker < Base
    include UI::Behaviors::Dropdown

    extend Forwardable

    tag 'ui-color-picker'

    component :input, UI::Input, spellcheck: false
    component :div, 'div'

    component :dropdown, UI::Dropdown do
      component :color_panel, UI::ColorPanel
    end

    style display: 'inline-block',
          position: :relative,
          div: { boxShadow: '0 0 1px 1px rgba(0,0,0,0.2) inset',
                 borderRadius: -> { theme.border_radius.em },
                 pointerEvents: :none,
                 position: :absolute,
                 bottom: 0.3.em,
                 right: 0.3.em,
                 top: 0.3.em,
                 width: 2.em },
          input: { paddingRight: -> { (theme.size * 1.25).em },
                   boxSizing: 'border-box',
                   width: '100%' }

    on :change, :input, :update_dropdown
    on :change, 'ui-color-wheel', :update_input
    on :change, 'ui-color-wheel, input', :delegate_change

    def_delegators :input, :value
    def_delegators :dropdown, :color_panel

    dropdown :input, :dropdown

    # Delegates the change event
    # so the target would be the picker
    # not the color panel
    #
    # @param event [DOM::Event] The event
    def delegate_change(event)
      event.stop
      trigger :change
    end

    # Initializes the component:
    #
    # * When the input gets the focus
    #   update the dropdown.
    # * Set default value to **white**
    def initialize
      super
      @input.on(:focus) { update_dropdown }
      @input.value = '#FFFFFF'
    end

    # Sets the value of the component
    #
    # @param value [String] The CSS color (hex or named)
    def value=(value)
      @input.value = value
      update_dropdown
    end

    private

    # Updates the dropdown with the
    # inputs value:
    #
    # * If the color is invalid update the input
    # * Alwas render color of the rectange
    def update_dropdown
      color_panel.color = @input.value
    rescue
      update_input
    ensure
      render
    end

    # Update the value of the input
    # from the color panel.
    def update_input
      @input.value = '#' + color_panel.color.hex.upcase
      render
    end

    # Renders the rectange
    def render
      @div.style.background = '#' + color_panel.color.hex.upcase
    end
  end
end
