Fron::Sheet.helpers do
  # :reek:FeatureEnvy
  def rgba(color, percent)
    color = Color::RGB.by_css(color)
    "rgba(#{color.red}, #{color.green}, #{color.blue}, #{percent})"
  end

  def dampen(color, percent)
    color = Color::RGB.by_css(color)
    '#' + color.send((color.brightness > 0.5 ? :darken_by : :lighten_by), (1 - percent) * 100).hex
  end

  def readable_color(background)
    color = Color::RGB.by_css(background)
    inverze, mix = color.brightness > 0.5 ? [Color::RGB::Black, 40] : [Color::RGB::White, 7]
    '#' + color.mix_with(inverze, mix).hex
  end

  def theme
    @theme ||= OpenStruct.new font_family: 'Open Sans, sans-serif',
                              focus_box_shadow: -> { "0 0 0 2px #{dampen(colors.focus, 0.4)} inset" },
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
                              focus: '#2196F3',
                              input: '#FFF',
                              body: '#FEFEFE'
  end
end

Fron::Sheet.additional_styles = OPEN_SANS + "\n" + ION_ICONS
Fron::Sheet.add_rule 'body', { margin: 0, display: 'block !important', background: -> { colors.body }, color: -> { readable_color colors.body } }, '0'
