module UI
  module Behaviors
    module Rest
      def self.included(base)
        base.register self, [:rest]
      end

      def self.rest(item)
        @rest_options = OpenStruct.new item[:args].first
      end

      def update(data, &block)
        request :put, @data[:id], data, &block
      end

      def destroy(&block)
        request :delete, @data[:id], &block
      end

      def create(data)
        request :post, '', data do |response|
          yield response
        end
      end

      # :reek:FeatureEnvy
      def request(method, path, params = {})
        req = Fron::Request.new "#{@rest_options.url}/#{path}", 'Content-Type' => 'application/json'
        req.request method.upcase, params do |response|
          if (200..300).cover?(response.status)
            yield response.json
          else
            warn response.json['error']
          end
        end
      end
    end
  end
end
