module UI
  module Behaviors
    module File
      class << self
        def handle_change
          return unless file
          @instance.send(@instance._on_file_select, file)
          file_input.value = ''
        end

        def file_input
          @file_input ||= create_file_input
        end

        def file
          file_input.files[0]
        end

        def create_file_input
          input = DOM::Element.new :input
          input[:type] = :file
          input.on(:change) { handle_change }
          input >> DOM::Document.body
          input.hide
          input
        end

        def included(base)
          base.register self, [:on_file_select]
          base.attr_reader :_on_file_select
        end

        def select(instance)
          @instance = instance
          file_input.click
        end

        def on_file_select(item)
          @_on_file_select = item[:args][0]
        end
      end

      def select_file
        UI::Behaviors::File.select self
      end
    end
  end
end
