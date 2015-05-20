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

  def request(method, path, params = {})
    req = Fron::Request.new "#{@rest_options.url}/#{path}", 'Content-Type' => 'application/json'
    req.request method.upcase, params do |response|
      if (200..300).cover?(response.status)
        yield response.json
      else
        `console.warn(#{response.json['error']})`
      end
    end
  end
end

# Storage
class Storage
  def initialize(prefix)
    @prefix = prefix
  end

  def get(key)
    storage.get("#{@prefix}:#{key}").to_h
  end

  def set(key, data)
    storage.set("#{@prefix}:#{key}", data)
  end

  def remove(key)
    storage.remove("#{@prefix}:#{key}")
  end

  def all
    storage
      .keys
      .select { |key| key.start_with?(@prefix) }
      .map { |key| storage.get(key).to_h }
  end

  def storage
    Fron::Storage::LocalStorage
  end
end