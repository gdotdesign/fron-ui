module UI
  # Action
  class Action < Fron::Component
    include UI::Behaviors::Action

    tag 'ui-action'

    def initialize
      super
      self[:tabindex] ||= 0
    end
  end
end
