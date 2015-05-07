RSpec::Matchers.define :be_left_of do |expected|
  match do |actual|
    in_dom actual do
      actual.right <= expected.left
    end
  end
end
