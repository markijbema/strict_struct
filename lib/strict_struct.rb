#require "strict_struct/version"

module StrictStruct
  module Helper
    def self.assert_keyword_error type, keywords
      if keywords.length == 1
        raise ArgumentError, "#{type} keyword: " + keywords.first.to_s
      elsif keywords.length > 1
        raise ArgumentError, "#{type} keywords: " + keywords.join(', ')
      end
    end

    def self.validate_arguments given, expected
      missing_arguments = expected.reject {|name| given.include? name }
      Helper.assert_keyword_error "missing", missing_arguments

      extra_arguments = given.reject {|name| expected.include? name }
      Helper.assert_keyword_error "unknown", extra_arguments
    end
  end

  def self.new(*attributes, &block)
    klass = Class.new do
      @@attributes = attributes

      define_method :initialize do |hash={}|
        @hash = hash
        Helper.validate_arguments(@hash.keys, @@attributes)
      end

      attributes.each do |attribute|
        define_method(attribute) do
          @_strict_struct_hash[attribute]
        end
      end

      def to_h
        @hash
      end

      def == (other)
        @@attributes.all? {|name| self.send(name) == other.send(name)}
      end
    end
    klass.class_eval(&block) if block_given?
    klass
  end
end
