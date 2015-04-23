require 'opal'
require 'ostruct'
require 'fron'
require 'color'

require_tree 'fron-ui'

module UI
  Config = OpenStruct.new main_color: 'orangeRed',
                          font_family: 'sans, sans-serif'

  class << self
    def readable_color(background)
      color = Color::RGB.by_css(background)
      lightness = color.r * 0.299 + color.g * 0.587 + color.b * 0.114
      lightness > 0.5 ? '#000' : '#FFF'
    end
  end
end
