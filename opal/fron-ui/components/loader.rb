# rubocop:disable DoubleNegation

module UI
  # Loader component
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Loader < Base
    tag 'ui-loader'

    component :div, 'ui-loader-div'

    keyframes 'ui-loader', '0%' =>   { transform: 'rotate(0deg)' },
                           '50%' =>  { transform: 'rotate(179.9deg)' },
                           '100%' => { transform: 'rotate(359.9deg)' }

    style transition: 'opacity 320ms',
          justifyContent: :center,
          alignItems: :center,
          minHeight: 2.em,
          minWidth: 2.em,
          display: :flex,
          color: -> { colors.primary },
          opacity: 0,
          '&.loading' => {
            opacity: 1
          },
          'ui-loader-div' => {
            animation: 'ui-loader 1.2s infinite linear',
            border: '0.15em solid currentColor',
            borderTop: '0.15em solid transparent',
            borderBottom: '0.15em solid transparent',
            display: :flex,
            justifyContent: :center,
            alignItems: :center,
            borderRadius: '50%',
            height: 2.em,
            width: 2.em,
            '&:before' => {
              content: '""',
              border: '0.15em solid currentColor',
              borderRadius: '50%',
              height: 1.em,
              width: 1.em
            }
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
