# Collection component.
#
# A collection component reflects the underlying data (Array) with
# children.
class Collection < Fron::Component
  # Record
  class Record < Fron::Component
    include ::Record
  end

  attr_reader :items
  attr_writer :base, :key

  private

  # Initializes the collection
  def initialize
    super
    @items = []
  end

  # Sets items
  #
  # @param data [Array<Hash>] The data
  def items=(data)
    diff_items data
  end

  # Returns the key
  #
  # @return [String] the key
  def key
    @key || :id
  end

  # Diffs and patches existings items
  # with the given data.
  #
  # @param data [Array<Hash>] The data
  def diff_items(data)
    fail 'Not array given for collection!' unless data.is_a?(Array)

    # Get IDS
    new_ids = data.map do |item|
      # Raise error if the item doesn't have a key
      fail "No key(#{key}) found or nil for #{item}!" unless item[key]
      item[key]
    end
    old_ids = @items.map { |model| model.data[key] }

    # Delete old items
    @items.reject! do |model|
      includes = new_ids.include?(model.data[key])
      model.remove! unless includes
      !includes
    end

    # Update exsisting items
    @items.each do |model|
      model.data = data.find { |item| item[key] == model.data[key] }
    end

    # Create new items
    new_items = data.reject { |item| old_ids.include?(item[key]) }
    new_items.each do |item|
      @items << create_item(item)
    end

    # Keep the order of the original items
    @items.sort_by! { |item| data.find_index { |model| model[key] == item.data[key] } }
    render_items
  end

  # Renders the items, keeping old items
  # in the dom while adding new ones and
  # removeing old ones.
  def render_items
    @items.reverse_each_with_index do |item, index|
      # Skip if item is already in
      next if item.parent

      next_item = @items[index + 1]
      if next_item
        # If there is a nex item isert before it
        next_id = next_item.data[key]
        el = @items.find { |element| element.data[key] == next_id }
        insert_before item, el
      else
        # Else append at the end
        item >> self
      end
    end
  end

  # Creates a new item from the data
  #
  # @param data [Hash] The data
  #
  # @return [Fron::Component] The item
  def create_item(data)
    fail 'Base class does not include ::Record!' if @base && !@base.include?(::Record)
    item = (@base || Record).new
    item.data = data
    item
  end
end
