module UI
  # Base Component
  class Base < Fron::Component
    style '&[disabled]' => { pointerEvents: :none,
                             userSelect: :none }

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

    def flex=(value)
      @style.flex = value
    end
  end
end

module Fron
  # Sheet
  module Sheet
    class << self
      def autoprefixer
        @autoprefixer ||= `autoprefixer()`
      end

      def render
        text = @rules.map { |tag, data| "#{tag} { #{render_rule(data)} }" }.join("\n")
        style.text = `#{autoprefixer}.process(#{text}).toString()`
      end
    end
  end
end
