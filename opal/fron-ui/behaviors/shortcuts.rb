module UI
  module Behaviors
    module Shortcuts
      def self.included(base)
        base.register self, [:shortcut]
      end

      def self.shortcut(item)
        initialize_shortcuts
        shortcut, action = item[:args]
        shortcuts << { parts: shortcut.split(Fron::Keyboard::DELIMETERS), action: action }
      end

      def initialize_shortcuts
        @shortcut_event = DOM::Window.on(:keyup) do |event|
          break if DOM::Document.active_element
          break unless visible?

          combo = Fron::Keyboard.calculate_shortcut event

          shortcuts.each do |shortcut|
            next unless shortcut[:parts].sort == combo.sort
            send shortcut[:action]
            event.stop
            break
          end
        end
      end

      def shortcuts
        @shortcuts ||= []
      end
    end
  end
end
