module UI
  # Base component for elements that handle
  # *action* (enter or space) as well as clicks.
  #
  # @author Gusztáv Szikszai
  # @since 0.1.0
  class Action < Fron::Component
    include UI::Behaviors::Action

    tag 'ui-action'

    # Initializes the component by setting the tabindex.
    def initialize
      super
      self[:tabindex] ||= 0
    end
  end
end
