module UI
  module Behaviors
    module Serialize
      def load(data)
        data.each do |key, value|
          item = find("[name=#{key}]")
          next unless item
          item.value = value
        end
      end

      def data
        find_all('[name]').each_with_object({}) do |item, memo|
          memo[item[:name]] = item.value
        end
      end
    end
  end
end
