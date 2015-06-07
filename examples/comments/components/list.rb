class List < Collection
  # Tagname
  tag 'comments'

  # Styles
  style '> * + *' => { marginTop: -> { (theme.spacing * 2).em } }
end
