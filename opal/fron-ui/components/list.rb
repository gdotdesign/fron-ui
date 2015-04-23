module UI
  class List < Base
    tag 'ui-list'

    style overflow: :auto,
          '> *' => {
            display: :block,
            '&:nth-child(odd)' => {
              background: -> { Config.colors.background_lighter }
            }
          }
  end
end
