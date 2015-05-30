module UI
  module Behaviors
    # Behavior for seralizing and
    # deseralizing data from named
    # (having a name attribute) components
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Serialize
      # Populates items with the given data
      #
      # @param data [Hash] The data
      def load(data)
        @data = data
        find_all('[name]').each do |item|
          item.value = @data[item[:name]]
        end
      end

      # Gathers the data from elements
      #
      # :reek:FeatureEnvy
      #
      # @return [Hash] The data
      def data
        find_all('[name]').each_with_object(@data || {}) do |item, memo|
          memo[item[:name]] = item.value
        end
      end
    end
  end
end
