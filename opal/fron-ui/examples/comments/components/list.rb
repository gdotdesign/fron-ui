module Examples
  class Comments < UI::Container
    class List < Collection
      # Tagname
      tag 'ui-comments-list'

      # Styles
      style '> * + *' => { marginTop: -> { (theme.spacing * 2).em } }
    end
  end
end
