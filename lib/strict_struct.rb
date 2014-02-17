require "strict_struct/version"

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
    mod = Module.new do
      define_method :initialize do |hash={}|
        Helper.validate_arguments(hash.keys, attributes)
        @_strict_struct_hash = Hash[hash.to_a].freeze
      end

      attributes.each do |attribute|
        define_method(attribute) do
          @_strict_struct_hash[attribute]
        end
      end

      def to_h
        to_hash
      end

      def to_hash
        Hash[@_strict_struct_hash.to_a]
      end

      define_method :== do |other|
        return false unless self.class == other.class

        attributes.all? {|name| self.send(name) == other.send(name)}
      end

      define_method :hash do
        @_strict_struct_hash.hash
      end
    end
    klass = Class.new
    klass.send :include, mod
    klass.class_eval(&block) if block_given?
    klass
  end
end
