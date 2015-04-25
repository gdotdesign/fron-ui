module UI
  Config = OpenStruct.new font_family: 'sans, sans-serif',
                          focus_box_shadow: '0 0 1px 2px #90CAF9',
                          border_radius: 0.15,
                          spacing: 0.75,
                          size: 2.6
  Config.border_size = Config.size / 20
  Config.colors = OpenStruct.new primary: '#607D8B',
                                 success: '#43A047',
                                 danger: '#D32F2F',
                                 background: '#f3f3f3',
                                 background_lighter: '#f9f9f9',
                                 border: '#e6e6e6',
                                 focus: '#64B5F6',
                                 font: '#555'
end

class Numeric
  def em
    "#{self}em"
  end
end
