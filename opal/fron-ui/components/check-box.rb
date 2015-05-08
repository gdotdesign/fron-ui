module UI
  # Checkbox Component
  class Checkbox < Action
    extend Forwardable

    tag 'ui-checkbox'

    def_delegators :@input, :checked, :checked=

    component :input, :input, tabindex: -1, type: :checkbox
    component :label, :label, tabindex: -1 do
      component :icon, UI::Icon, glyph: :check
    end

    style display: 'inline-block',
          height: -> { theme.size.em },
          width: -> { theme.size.em },
          input: {
            display: :none,
            '&:checked + label' => {
              'ui-icon' => {
                transform: 'scale(1)',
                opacity: 1
              }
            }
          },
          label: {
            borderRadius: -> { theme.border_radius.em },
            transition: 'opacity 320ms, transform 320ms',
            background: -> { colors.primary },
            color: -> { readable_color(colors.primary) },
            justifyContent: :center,
            alignItems: :center,
            cursor: :pointer,
            height: :inherit,
            display: :flex,
            width: :inherit,
            'ui-icon.fa' => {
              transform: 'scale(0.4) rotate(45deg)',
              transition: :inherit,
              fontSize: 1.em,
              opacity: 0
            }
          },
          '&:focus label' => {
            boxShadow: -> { theme.focus_box_shadow }
          }

    keydown [:enter, :space], :toggle

    def action
      self.checked = !checked
      trigger :change
    end

    # Initializes the check box
    def initialize
      super
      self[:tabindex] = 0
      id = `Math.uuid(5)`
      @input[:id]   = id
      @input[:name] = id
      @label[:for]  = id
    end
  end
end
