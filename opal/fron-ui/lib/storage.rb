# Class for handling local storage
# items with a prefix
#
# @author Gusztáv Szikszai
# @since 0.1.0
class Storage
  # Initializes the instance
  # with the given prefix
  #
  # @param prefix [String, Symbol] The prefix
  def initialize(prefix)
    @prefix = prefix
  end

  # Gets the value from given key from the storage
  #
  # @param key [String, Symbol] The key
  #
  # @return The value
  def get(key)
    storage.get("#{@prefix}:#{key}").to_h
  end

  # Saves the given key and data in to the storage
  #
  # @param key [String, Symbol] the key
  # @param data The data
  def set(key, data)
    storage.set("#{@prefix}:#{key}", data)
  end

  # Removes the given key from the storage
  #
  # @param key [String, Symbol] The key
  def remove(key)
    storage.remove("#{@prefix}:#{key}")
  end

  # Returns all items in the store
  #
  # @return [Array] The items
  def all
    storage
      .keys
      .select { |key| key.start_with?(@prefix) }
      .map { |key| storage.get(key).to_h }
  end

  private

  # Returns the local storage
  #
  # @return [Fron::Storage::LocalStorage]
  def storage
    Fron::Storage::LocalStorage
  end
end
