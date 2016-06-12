class Debounce
  def initialize(delay, &block)
    @id = nil
    @block = block
    @delay = delay
  end

  def call
    clear_timeout @id
    @id = timeout @delay do
      @block.call
    end
  end
end
