module UI
  class List < Base
    tag 'ui-list'

    style overflow: :auto,
          '> *' => {
            display: :block,
            '&.even' => {
              background: -> { colors.background_lighter }
            }
          },
          '&.empty:after' => {
            padding: -> { (theme.spacing * 3).em },
            content: 'attr(empty_message)',
            textAlign: :center,
            display: :block,
            fontSize: 2.em,
            opacity: 0.25
          }

    def render
      toggle_class :empty, visible_items.empty?
      visible_items.each_with_index do |item, index|
        item.remove_class :odd
        item.remove_class :even
        item.add_class index.even? ? :even : :odd
      end
    end

    def visible_items
      children.select(&:visible?)
    end
  end
end
