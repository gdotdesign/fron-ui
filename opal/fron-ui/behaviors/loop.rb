module UI
  module Behaviors
    module Loop
      # Update / Render Loop
      def self.included(base)
        base.register self, [:act]
      end

      def data
        @data ||= {}
      end

      def update!(type, *args)
        if type.is_a?(Array)
          type.each { |item| update_act(*item) }
        else
          update_act(type, *args)
        end
        raise "Could not render #{self} because it's not defined!" unless respond_to?(:render)
        render
      end

      def replace!(data)
        @data = data
        render
      end

      def update_act(type, *args)
        raise "There is no update with the name #{type}!" unless @acts[type]
        updated_data = @acts[type].call(*(args + [data]))
        raise "Update didn't return a hash insted I got #{udpated_data}!" unless updated_data.is_a?(Hash)
        data.merge! updated_data
      end

      def self.act(item)
        @acts ||= {}
        @acts[item[:args].first] = item[:block]
      end
    end
  end
end
