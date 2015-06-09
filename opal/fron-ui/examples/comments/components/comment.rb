class Comment < UI::Container
  # Includes
  include UI::Behaviors::Confirmation
  include UI::Behaviors::Actions
  include UI::Behaviors::Rest
  include ::Record

  # REST
  rest url: 'http://localhost:3000/comments'

  # Tagname
  tag 'comment'

  # Style
  style 'comment-body' => { borderBottom: -> { "#{(theme.border_size / 2).em} solid #{colors.background}" },
                            paddingBottom: -> { theme.spacing.em } },
        '&:hover comment-header ui-action' => { display: :block },
        'comment-body p' => { margin: 0,
                              '& + p' => { marginTop: -> { theme.spacing.em } } }

  # Components
  component :image, UI::Image, width: 4.em, height: 4.em
  component :box, UI::Container, flex: 1 do
    component :header, Header, direction: :row
    component :body, 'comment-body'
    component :footer, Footer, direction: :row
  end

  # Confirmation for destroy
  confirmation :destroy!, 'Are you sure?'

  # Initializes the comment by setting
  # the direction attribute
  def initialize
    super
    self[:direction] = :row
  end

  # Votes up the comment
  def vote_up
    update_votes(1)
  end

  # Votes down the comment
  def vote_down
    update_votes(-1)
  end

  # Updates the vote count by the given number
  #
  # @param count [Integer] The count
  def update_votes(count)
    update votes: @data[:votes] + count do |data|
      self.data = data
    end
  end

  # Destroys the comment and trigger refresh
  def destroy!
    destroy { trigger :refresh }
  end

  # Renders the comment
  def render
    @image.src = @data[:user][:image]
    @box.body.html = @data[:body]
    @box.header.render @data
    @box.footer.render @data
  end
end
