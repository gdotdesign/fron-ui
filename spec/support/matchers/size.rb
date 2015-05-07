RSpec::Matchers.define :be_size_of do |*expected|
  match do |actual|
    in_dom actual do
      @values = [actual.width, actual.height]
      @values == expected
    end
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be size of [#{expected}] got [#{@values}}]"
  end
end
