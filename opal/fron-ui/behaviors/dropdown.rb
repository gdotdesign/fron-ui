module UI
  module Behaviors
    # Actions
    module Dropdown
      def self.included(base)
        base.register self, [:dropdown]
      end

      def self.dropdown(item)
        input, dropdown = item[:args].map { |id| instance_variable_get("@#{id}") }
        input.on(:focus) { dropdown.open }
        input.on(:blur)  { dropdown.close }
      end
    end
  end
end
