#require "value_object/version"

module ValueObject
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

    def self.raise_no_method(method_name, object)
      raise NoMethodError, "undefined method `#{method_name}' for #{object.inspect}"
    end
  end

  def self.new(*attributes, &block)
    klass = Class.new do
      @@attributes = attributes

      define_method :initialize do |hash={}|
        @hash = hash
        Helper.validate_arguments(@hash.keys, @@attributes)
      end

      def method_missing(method, *args)
        Helper.raise_no_method(method, self) unless @hash.key? method.to_sym

        @hash[method.to_sym]
      end

      def respond_to_missing?(method, include_all=false)
        @hash.key? method.to_sym
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
