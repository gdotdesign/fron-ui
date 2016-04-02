# UI Module
module UI
  # Base Component
  class Base < Fron::Component
    tag 'ui-base'

    style '&[disabled]' => { pointerEvents: :none,
                             userSelect: :none,
                             opacity: 0.4 }

    attribute_accessor :tabindex

    # Disabled state
    #
    # * Doesn't trigger events -> ???
    # * Not selectable -> pointer-events: none;
    # * Cannot be tabbed -> remove tabindex if there is one?
    def disabled=(value)
      super
      if disabled
        self[:_tabindex] = self[:tabindex] if self[:tabindex]
        remove_attribute :tabindex
        self[:disabled] = ''
      else
        self[:tabindex] = self[:_tabindex] if self[:_tabindex]
        remove_attribute :_tabindex
        remove_attribute :disabled
      end
    end

    # Sets the readonly state
    #
    # @param value [Boolean] The value
    def readonly=(value)
      if value
        self[:readonly] = ''
      else
        remove_attribute :readonly
      end
    end

    # Sets the flex value
    #
    # @param value [Numeric] The value
    def flex=(value)
      @style.flex = value
    end
  end
end
