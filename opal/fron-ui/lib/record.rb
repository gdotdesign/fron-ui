# Record module
module Record
  # Sets up the record
  #
  # @param other [Fron::Component] The includer
  def self.included(other)
    other.attr_reader :data
  end

  # Sets the data
  #
  # @param data [Hash] The data
  def data=(data)
    @data = data
    render
  end

  # Renders the component
  def render
    return unless data
    self.text = data.inspect
  end
end
