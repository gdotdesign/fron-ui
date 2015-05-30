# UI Module
module UI
  # Base Component
  class Base < Fron::Component
    style '&[disabled]' => { pointerEvents: :none,
                             userSelect: :none }

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

    # Sets the flex value
    #
    # @param value [Numeric] The value
    def flex=(value)
      @style.flex = value
    end
  end
end

# Fron
module Fron
  # Sheet
  module Sheet
    class << self
      # Returns the autoprefixer instance
      #
      # @return [Native] The instance
      def autoprefixer
        @autoprefixer ||= `autoprefixer()`
      end

      # Renders with autoprefixer
      def render
        text = @rules.map { |tag, data| "#{tag} { #{render_rule(data)} }" }.join("\n")
        style.text = `#{autoprefixer}.process(#{text}).toString()`
      end
    end
  end
end
