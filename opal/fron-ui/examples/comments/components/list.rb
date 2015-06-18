module Examples
  class Comments < UI::Container
    # Comment List
    class List < Collection
      # Tagname
      tag 'ui-comments-list'

      # Styles
      style '> * + *' => { marginTop: -> { (theme.spacing * 2).em } }
    end
  end
end
