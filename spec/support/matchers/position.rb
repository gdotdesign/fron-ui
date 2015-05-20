class LayoutMatchers
  class << self
    def position(actual, expected, actual_side, expected_side, spacing)
      diff = nil
      result = in_dom actual do
        in_dom expected do
          actual_position = actual.send(actual_side)
          expected_position = expected.send(expected_side)

          first = actual_position <= expected_position
          return [first, nil] unless spacing
          diff = (expected_position - actual_position).abs
          diff == spacing && first
        end
      end
      [result, diff]
    end

    def aligned(actual, expected, side)
      in_dom actual do
        in_dom expected do
          actual.send(side) == expected.send(side)
        end
      end
    end

    private

    def in_dom(el)
      return yield if DOM::Document.body.include?(el)
      el = el.parent while el.parent
      el >> DOM::Document.body
      yield
    ensure
      el.remove!
    end
  end
end

{
  be_left_of: {
    actual_side: :right,
    expected_side: :left,
    failure_message: proc do |actual|
      "expected #{actual} to be left of #{expected} by #{@spacing}px but it's #{@diff}px"
    end
  },
  be_right_of: {
    actual_side: :left,
    expected_side: :right,
    failure_message: proc do |actual|
      "expected #{actual} to be right of #{expected} by #{@spacing}px but it's #{@diff}px"
    end
  }
}.each do |matcher, data|
  RSpec::Matchers.define matcher do |expected|
    match do |actual|
      result, @diff = LayoutMatchers.position(actual,
                                              expected,
                                              data[:actual_side],
                                              data[:expected_side],
                                              @spacing)
      result
    end

    chain :by do |spacing|
      @spacing = spacing
    end

    failure_message_for_should do |actual|
      instance_exec(actual, &data[:failure_message])
    end
  end
end

{
  aligned_horizontally_top: :top,
  aligned_horizontally_bottom: :bottom
}.each do |matcher, side|
  RSpec::Matchers.define matcher do |expected|
    match do |actual|
      LayoutMatchers.aligned(actual, expected, side)
    end
  end
end
