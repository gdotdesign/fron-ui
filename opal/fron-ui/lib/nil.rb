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
