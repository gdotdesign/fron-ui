module UI
  class Checkbox < Fron::Component
    extend Forwardable

    tag 'ui-checkbox'

    def_delegators :@input, :checked, :checked=

    component :input, :input, type: :checkbox
    component :label, :label do
      component :icon, UI::Icon, glyph: :check
    end

    style display: 'inline-block',
          borderRadius: -> { Config.border_radius.em },
          overflow: 'hidden',
          height: -> { Config.size.em },
          width: -> { Config.size.em },
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
            borderStyle: :solid,
            borderWidth: -> { (Config.size / 13).em },
            boxSizing: 'border-box',
            borderColor: -> { Config.colors.primary },
            color: -> { Config.colors.primary },
            justifyContent: :center,
            alignItems: :center,
            transition: '320ms',
            cursor: :pointer,
            height: :inherit,
            display: :flex,
            width: :inherit,
            'ui-icon.fa' => {
              transform: 'scale(0.4) rotate(45deg)',
              transition: :inherit,
              opacity: 0
            }
          }

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
