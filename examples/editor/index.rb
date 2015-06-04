require 'fron_ui'

class Main < UI::Container
  style padding: -> { theme.spacing.em },
        boxSizing: 'border-box',
        height: '100vh'

  component :container, UI::Container, direction: :row, flex: 1 do
    component :sidebar, UI::Box do
      component :title, UI::Title, text: 'Files'
    end
    component :content, UI::Box, flex: 1 do
      component :tabs, UI::Tabs, flex: 1 do
        component :tab, UI::Tabs::Tab, tab: 'test.rb'
        component :tab, UI::Tabs::Tab, tab: 'test2.rb'
      end
    end
  end
end

main = Main.new

DOM::Document.body << main
