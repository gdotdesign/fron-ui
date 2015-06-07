class ThemeRoller < UI::Box
  include UI::Behaviors::Render

  component :title, UI::Title, text: 'Theme Roller', align: :center

  style position: :absolute,
        right: 2.em,
        top: 2.em

  on :change, :set

  def initialize
    super
    Fron::Sheet.helper.theme.to_h.each do |key, value|
      create_input key, value
    end
    Fron::Sheet.helper.colors.to_h.each do |key, value|
      input = UI::ColorPicker.new
      input[:name] = key
      input.value = value
      self << input
    end
  end

  def create_input(key, value)
    return unless value.class == Numeric
    input = UI::NumberRange.new
    input[:name] = key
    input.step = 0.1
    input.value = value
    input.affix = :em
    input.label = "#{key}:"
    self << input
  end

  def set(event)
    key = event.target[:name]
    value = event.target.value
    if key == :font_size
      DOM::Document.body.style.fontSize = value.px
    elsif value.to_s.start_with?('#')
      Fron::Sheet.helper.colors[key] = value
      Fron::Sheet.render
    else
      Fron::Sheet.helper.theme[key] = value
      Fron::Sheet.render
    end
  end
end
