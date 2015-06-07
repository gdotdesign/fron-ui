module UI
  # Checkbox component.
  #
  # Features:
  # * checked and checked=
  # * actionable
  #
  # @attr value [Boolean] The value
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
                   color: -> { readable_color colors.input },
                   background: -> { colors.input },
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
          '&:focus label' => { boxShadow: -> { theme.focus_box_shadow.call } }

    on :click, :action

    # Toggles the checkbox
    def action
      self.checked = !checked
      trigger :change
    end

    alias_method :value=, :checked=
    alias_method :value, :checked
  end
end
