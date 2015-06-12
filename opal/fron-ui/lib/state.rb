# Class for managing states in the application
# mainly in the form of a string, for exmaple:
# (hash:value,hash:[value,value2,(hash3:value2)])
#
# Features
# * Encodes string values to be used in url
# * Handles recursives structures such as hashes and arrays
# * Can be extended with additional classes easily
#
# @author Gusztáv Szikszai
# @since 0.1
class State
  # MAP of encoding / decodings for classes
  MAP = {
    String => { encode: -> (item) { `escape(#{item})` } },
    Numeric => { encode: -> (item) { item.to_s } },
    Integer => { encode: -> (item) { item.to_s },
                 decode: -> (str) { str.to_i },
                 match: /^[0-9]+$/ },
    Float => { encode: -> (item) { item.to_s },
               decode: -> (str) { str.to_f },
               match: /^[0-9]+\.[0-9]+$/ },
    Hash => { encode: -> (item) { '(' + item.map { |key, value| "#{encode(key)}:#{encode(value)}" }.join(',') + ')' },
              match: /^\([^\)]+\)$/,
              recursive: /\(([^()])*\)/,
              decode: lambda do |str|
                str[1..-2].split(',').each_with_object({}) do |item, memo|
                  key, value = item.split(':')
                  memo[decode(key)] = decode(value)
                end
              end
            },
    Array => { encode: -> (array) { "[#{array.map { |item| encode(item) }.join(',')}]" },
               decode: -> (str)  { str[1..-2].split(',').map { |item| decode(item) } },
               recursive: /\[([^\[\]])*\]/,
               match: /^\[[^\]]*\]$/ }
  }

  class << self
    # Decodes the given string into ruby objects.
    #
    # @param string [String] The string
    #
    # @return The decoded value
    def decode(string)
      with_rec_map do
        # Replace recursive types with placeholders
        string = replace_recursives string
        # Decode part represented with the placeholder
        return decode(@rec_map[string]) if string.is_a?(String) && string.start_with?('$')

        # Try to decode the string by
        # matching the given regexpes
        decoded = nil
        map.values.each do |item|
          next unless string =~ item.match
          decoded = instance_exec string, &item.decode
        end

        # If we couldn't decode the value
        # it's a string or unkown type
        # that we treat as string
        decoded || `unescape(#{string})`
      end
    end

    # Encodes the given data into a string,
    # throws an error if the data can't be serialized.
    #
    # @param data The data
    #
    # @return [type] [description]
    def encode(data)
      fail "Cannot serialize #{data.class}, there is no implementation!" unless map[data.class]
      instance_exec data, &map[data.class].encode
    end

    private

    # Replaces the recursive structures
    # in the given string with placeholders.
    #
    # @param string [String] The input string
    #
    # @return [String] The string with placeholders
    def replace_recursives(string)
      index = @rec_map.keys.count
      map.values.select(&:recursive).each do |item|
        next if string =~ item.match
        while string =~ item.recursive
          string = string.gsub(item.recursive) do |match|
            name = "$#{index}"
            @rec_map[name] = match
            index += 1
            name
          end
        end
      end
      string
    end

    # Handles the rec_map instance variable
    # during the decoding process.
    def with_rec_map
      return yield if @rec_map
      @rec_map = {}
      ret = yield
      @rec_map = nil
      ret
    end

    # Returns the map as OpenStruct
    #
    # @return [Hash] The map with values as OpenStruct
    def map
      return @map if @map
      @map = {}
      MAP.each do |key, value|
        @map[key] = OpenStruct.new(value)
      end
      @map
    end
  end
end
