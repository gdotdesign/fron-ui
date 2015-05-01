module UI
  module Behaviors
    # Render
    module Render
      def self.included(base)
        base.register self, [:render]
        base.define_method :render do
          @render_proc.call
        end
      end

      def self.render(item)
        @render_proc = Fron::RenderProc.new method(item[:args].first)
      end
    end
  end
end
