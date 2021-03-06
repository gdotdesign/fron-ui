# NilClass
class NilClass
  # Try
  def try
    nil
  end
end

# Object
class Object
  # Try
  #
  # @param method [Symbol] The method
  #
  # @return The return value
  def try(method)
    send(method) if respond_to?(method)
  end
end

class Array
  # Returns the vaue for the given key for
  # each Hash in the array.
  #
  # @return [Array] The array
  def pluck(key)
    select { |item| item.is_a?(Hash) }.map { |item| item[key] }
  end
end
