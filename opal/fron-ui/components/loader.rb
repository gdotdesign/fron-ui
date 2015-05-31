# rubocop:disable DoubleNegation

module UI
  # Loader component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Loader < Base
    tag 'ui-loader'

    component :div, 'ui-loader-div'

    keyframes 'ui-loader', '0%' =>   { transform: 'perspective(120px) rotateX(0deg) rotateY(0deg)' },
                           '50%' =>  { transform: 'perspective(120px) rotateX(-180.1deg) rotateY(0deg)' },
                           '100%' => { transform: 'perspective(120px) rotateX(-180deg) rotateY(-179.9deg)' }

    style transition: 'opacity 320ms',
          justifyContent: :center,
          alignItems: :center,
          minHeight: 2.em,
          minWidth: 2.em,
          display: :flex,
          opacity: 0,
          '&.loading' => {
            opacity: 1
          },
          'ui-loader-div' => {
            animation: 'ui-loader 1.2s infinite ease-in-out',
            background: -> { colors.primary },
            height: 2.em,
            width: 2.em
          }

    # Sets the loading flag
    #
    # @param value [Boolean] The value
    def loading=(value)
      toggle_class :loading, !!value
    end

    # Returns the loading flag
    #
    # @return [Boolean] The value
    def loading
      has_class(:loading)
    end
  end
end
