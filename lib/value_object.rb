#require "value_object/version"

module ValueObject
  def self.new(*names, &block)
    klass = Class.new do
      def initialize hash={}
        @hash = hash
      end

      def method_missing(method, *args)
        @hash[method.to_sym]
      end

      def respond_to_missing?(method, include_all=false)
        @hash.key? method.to_sym
      end

      def to_h
        @hash
      end

      define_method(:==) do |other|
        names.all? {|name| self.send(name) == other.send(name)}
      end
    end
    klass.class_eval(&block) if block_given?
    klass
  end
end
