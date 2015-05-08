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

    def flex=(value)
      @style.flex = value
    end

    def self.component_delegators(accessor, *methods)
      methods.each do |name|
        alias_method "___#{name}", name
        define_method name do |*args, &block|
          el = instance_variable_get("@#{accessor}")
          if el
            el.__send__(name, *args, &block)
          else
            send("___#{name}", *args, &block)
          end
        end
      end
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
