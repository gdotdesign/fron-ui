module UI
  # Checkbox component.
  #
  # Features:
  # * checked and checked=
  # * actionable
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Checkbox < Action
    extend Forwardable

    tag 'ui-checkbox'

    def_delegators :@input, :checked, :checked=

    component :input, :input, tabindex: -1, type: :checkbox
    component :label, :label, tabindex: -1 do
      component :icon, UI::Icon, glyph: :checkmark
    end

    style height: -> { theme.size.em },
          width: -> { theme.size.em },
          display: 'inline-block',
          input: { display: :none,
                   '&:checked + label' => { 'ui-icon' => { transform: 'scale(1)',
                                                           opacity: 1 } } },
          label: { transition: 'opacity 320ms, transform 320ms',
                   borderRadius: -> { theme.border_radius.em },
                   background: -> { colors.input },
                   color: -> { colors.font },
                   justifyContent: :center,
                   alignItems: :center,
                   cursor: :pointer,
                   height: :inherit,
                   display: :flex,
                   width: :inherit,
                   'ui-icon' => { transform: 'scale(0.4) rotate(45deg)',
                                  transition: :inherit,
                                  fontSize: 1.em,
                                  opacity: 0 } },
          '&:focus label' => { boxShadow: -> { theme.focus_box_shadow } }

    # Toggles the checkbox
    def action
      self.checked = !checked
      trigger :change
    end

    # Initializes the check box
    # * Sets the tabindex
    # * Adds unique id for the label to work
    def initialize
      super
      id = `Math.uuid(5)`
      @input[:id]   = id
      @label[:for]  = id
    end
  end
end
