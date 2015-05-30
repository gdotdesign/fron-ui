module UI
  # Behavior for giving a component REST methods.
  #
  # @see http://en.wikipedia.org/wiki/Representational_state_transfer
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  module Behaviors
    module Rest
      # Sets up the behavior.
      #
      # @param base [Fron::Component] The includer
      def self.included(base)
        base.register self, [:rest]
      end

      # Sets the rest options from the registry
      #
      # @param item [Hash] The item
      def self.rest(item)
        @rest_options = OpenStruct.new item[:args].first
      end

      # Updates the model with the given data.
      #
      # @param data [Hash] The data
      #
      # @yield The updated data
      def update(data, &block)
        request :put, @data[:id], data, &block
      end

      # Destroyes the model, yields
      # if was successfull.
      def destroy(&block)
        request :delete, @data[:id], &block
      end

      # Creates a new model with the given data.
      #
      # @param data [Hash] The data
      #
      # @yield The actual created data
      def create(data, &block)
        request :post, '', data, &block
      end

      # Makes a requests to server
      #
      # :reek:FeatureEnvy
      #
      # @param method [Symbol, String] The request method
      # @param path [String] The URL
      # @param params [Hash] The parameters
      #
      # @yield [Hash] The returned data
      def request(method, path, params = {})
        req = create_request path
        req.request method.upcase, params do |response|
          if (200..300).cover?(response.status)
            yield response.json if block_given?
          else
            warn response.json['error']
          end
        end
      end

      private

      # Creates a request object
      #
      # @param path [String] The URL
      #
      # @return [Fron::Request] The request
      def create_request(path)
        Fron::Request.new "#{@rest_options.url}/#{path}", 'Content-Type' => 'application/json'
      end
    end
  end
end
