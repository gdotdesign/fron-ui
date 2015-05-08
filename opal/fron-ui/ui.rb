Fron::Sheet.helpers do
  def readable_color(background)
    color = Color::RGB.by_css(background)
    lightness = color.r * 0.299 + color.g * 0.587 + color.b * 0.114
    lightness > 0.5 ? '#000' : '#FFF'
  end

  def theme
    @theme ||= OpenStruct.new font_family: 'sans, sans-serif',
                              focus_box_shadow: '0 0 0.07em 0.14em #90CAF9',
                              border_radius: 0.15,
                              border_size: 0.2,
                              spacing: 0.75,
                              size: 2.2
  end

  def colors
    @color ||= OpenStruct.new primary: '#607D8B',
                              success: '#43A047',
                              danger: '#D32F2F',
                              background: '#f3f3f3',
                              background_lighter: '#f9f9f9',
                              border: '#e6e6e6',
                              focus: '#2196F3',
                              font: '#555',
                              input: '#FFF'
  end
end
