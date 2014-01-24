require 'spec_helper'
require 'value_object'

describe 'ValueObject' do
  describe 'initialization' do
    it "works without parameters" do
      foo = ValueObject.new

      a_foo = foo.new

      a_foo.should_not be_nil
    end

    it "works with parameters" do
      foo = ValueObject.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.should_not be_nil
    end

    it "raises an error when an argument is missing" do
      foo = ValueObject.new(:x)

      expect do
        foo.new()
      end.to raise_error ArgumentError, "missing keyword: x"
    end

    it "raises an error when multiple arguments are missing" do
      foo = ValueObject.new(:x, :y, :z)

      expect do
        foo.new(z: 'bar')
      end.to raise_error ArgumentError, "missing keywords: x, y"
    end

    it "raises an error when an unknown argument is passed in" do
      foo = ValueObject.new(:x)

      expect do
        foo.new(x: 'foo', z: 'bar')
      end.to raise_error ArgumentError, "unknown keyword: z"
    end

    it "raises an error when multiple unknown argument are passed in" do
      foo = ValueObject.new(:x)

      expect do
        foo.new(x: 'foo', z: 'bar', w: 'baz')
      end.to raise_error ArgumentError, "unknown keywords: z, w"
    end

    it "raises a missing error when both missing arguments and unknown arguments are passed in" do
      foo = ValueObject.new(:x, :y)

      expect do
        foo.new(x: 'foo', w: 'baz')
      end.to raise_error ArgumentError, "missing keyword: y"
    end
  end

  describe 'defining one' do
    it "allows to define methods using block" do
      rectangle_class = ValueObject.new(:x, :y) do
        def area
          x * y
        end
      end

      rectangle = rectangle_class.new(x: 3, y: 5)

      rectangle.area.should == 15
    end
  end

  describe "attribute readers" do
    it "returns the value initialized with" do
      foo = ValueObject.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.bar.should eq 'baz'
      a_foo.should respond_to 'bar'
    end

    it "is not defined when the value isn't defined by the class" do
      foo = ValueObject.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.should_not respond_to 'gerard'
    end

    it "raises a NoMethodError when called for a value which isn't defined" do
      foo = ValueObject.new(:x)
      a_foo = foo.new(x: 3)

      expect do
        a_foo.y
      end.to raise_error NoMethodError, "undefined method `y' for #{a_foo.inspect}"
    end
  end


  describe '#to_h' do
    it "returns all the values the object is defined by" do
      foo = ValueObject.new(:bar, :baz)

      a_foo = foo.new(bar: 'baz', baz: 3)

      a_foo.to_h.should eq({bar: 'baz', baz: 3})
    end
  end

  describe '#==' do
    it "returns true if the values are the same" do
      foo = ValueObject.new(:bar)

      a_foo = foo.new(bar: 'baz')
      another_foo = foo.new(bar: 'baz')

      a_foo.should eq another_foo
    end
    it "returns true if the values are the same" do
      foo = ValueObject.new(:bar)

      a_foo = foo.new(bar: 'baz')
      another_foo = foo.new(bar: 'not_baz')

      a_foo.should_not eq another_foo
    end
  end
end
