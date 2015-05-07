module UI
  module Behaviors
    # Serialize
    module Serialize
      def load(data)
        @data = data
        find_all('[name]').each do |item|
          item.value = @data[item[:name]]
        end
      end

      def data
        find_all('[name]').each_with_object(@data || {}) do |item, memo|
          memo[item[:name]] = item.value
        end
      end
    end
  end
end
