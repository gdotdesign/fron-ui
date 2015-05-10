# Image
# TODO: move to components
class Image < Fron::Component
  tag 'ui-image'

  component :img, :img

  style display: 'inline-block',
        background: -> { colors.background_lighter },
        borderRadius: -> { (theme.border_radius * 2).em },
        img: {
          borderRadius: :inherit,
          width: :inherit,
          height: :inherit,
          transition: '320ms',
          opacity: 0,
          '&.loaded' => {
            opacity: 1
          }
        }

  def initialize
    super
    @img.on(:load) { loaded }
  end

  def loaded
    @img.add_class :loaded
  end

  def width=(value)
    @style.width = value
  end

  def height=(value)
    @style.height = value
  end

  def src
    @img[:src]
  end

  def src=(value)
    return if !value || @img[:src] == value
    @img.remove_class :loaded
    timeout 320 do
      @img[:src] = value
    end
  end
end
