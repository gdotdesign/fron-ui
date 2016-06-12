# Component for setting the values of
# the theme (colors, spacing, border, ect...)
#
# @author Gusztáv Szikszai
# @since 0.1.0
class ThemeRoller < UI::Box
  include UI::Behaviors::Render

  component :title, UI::Title, text: 'Theme Roller', align: :center

  on :change, :set

  # Initializes the theme roller by
  # creating the input fields.
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

  # Creates an input by the key and value.
  #
  # @param key [String] The key
  # @param value The value
  #
  # @return [UI::Base] The input feld
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

  # Handles the change of the input fields.
  #
  # @param event [DOM::Event] The event
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
