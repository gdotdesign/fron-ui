module ImageLoader
  def self.load(src)
    image = DOM::Element.new('img')
    image.src = src

    promise = Promise.new

    image.on(:load) { promise.resolve }
    image.on(:error) { promise.reject }

    promise
  end
end
