module UI
  module Behaviors
    # Behavior for giving a component REST methods.
    #
    # @see http://en.wikipedia.org/wiki/Representational_state_transfer
    #
    # @author Gusztáv Szikszai
    # @since 0.1.0
    module Rest
      extend Fron::Eventable

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

      # Destroyes the model
      #
      # @yield if the action was successfull
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

      # Returns all recrods
      #
      # @yieldreturn [Array<Hash>] The recrods
      def all(&block)
        request :get, '', &block
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
          if response.status == 0
            raise_error :no_connection, "Could not connect to: #{req.url}"
          elsif (200..300).cover?(response.status)
            yield response_json(response) if block_given?
          else
            raise_error :wrong_status, response_json(response)['error']
            yield nil
          end
        end
      end

      private

      # Raises an error on the parent class.
      #
      # @param type [Symbol] The type
      # @param message [String] The message
      def raise_error(type, message)
        UI::Behaviors::Rest.trigger type, message
        UI::Behaviors::Rest.trigger :error, [type, message]
        warn message
      end

      # Tries to parse the json response,
      # raises error if it's invalid.
      #
      # @param response [Fron::Response] The response
      #
      # @return [Hash] The parsed data
      def response_json(response)
        response.json
      rescue StandardError
        raise_error :invalid_json, 'Invalid JSON data!'
      end

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
