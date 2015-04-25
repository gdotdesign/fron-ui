module UI
  class << self
    def readable_color(background)
      puts background
      color = Color::RGB.by_css(background)
      lightness = color.r * 0.299 + color.g * 0.587 + color.b * 0.114
      lightness > 0.5 ? '#000' : '#FFF'
    end
  end
end
