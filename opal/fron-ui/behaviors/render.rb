module UI
  module Behaviors
    # Behavior for rendering with requestAnimationFrame
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Render
      # Sets up the behavior:
      #
      # * Defines the render method that will call
      #   the render proc
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.register self, [:render]
        base.define_method :render do |&block|
          @render_proc.call
          block.call if block
        end
      end

      # Defines the render proc from the item
      #
      # @param item [Hash] The arguments
      def self.render(item)
        @render_proc = Fron::RenderProc.new method(item[:args].first)
      end
    end
  end
end
