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
