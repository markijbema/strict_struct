require 'spec_helper'
require 'strict_struct'

describe 'StrictStruct' do
  describe 'initialization' do
    it "works without parameters" do
      foo = StrictStruct.new

      a_foo = foo.new

      a_foo.should_not be_nil
    end

    it "works with parameters" do
      foo = StrictStruct.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.should_not be_nil
    end

    it "raises an error when an argument is missing" do
      foo = StrictStruct.new(:x)

      expect do
        foo.new()
      end.to raise_error ArgumentError, "missing keyword: x"
    end

    it "raises an error when multiple arguments are missing" do
      foo = StrictStruct.new(:x, :y, :z)

      expect do
        foo.new(z: 'bar')
      end.to raise_error ArgumentError, "missing keywords: x, y"
    end

    it "raises an error when an unknown argument is passed in" do
      foo = StrictStruct.new(:x)

      expect do
        foo.new(x: 'foo', z: 'bar')
      end.to raise_error ArgumentError, "unknown keyword: z"
    end

    it "raises an error when multiple unknown argument are passed in" do
      foo = StrictStruct.new(:x)

      expect do
        foo.new(x: 'foo', z: 'bar', w: 'baz')
      end.to raise_error ArgumentError, "unknown keywords: z, w"
    end

    it "raises a missing error when both missing arguments and unknown arguments are passed in" do
      foo = StrictStruct.new(:x, :y)

      expect do
        foo.new(x: 'foo', w: 'baz')
      end.to raise_error ArgumentError, "missing keyword: y"
    end

    it "doesn't influence initialisation of another class" do
      first = StrictStruct.new(:x)
      second = StrictStruct.new(:y)

      x = first.new(x: 3)
    end
  end

  describe 'defining one' do
    it "allows to define methods using block" do
      rectangle_class = StrictStruct.new(:x, :y) do
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
      foo = StrictStruct.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.bar.should eq 'baz'
      a_foo.should respond_to 'bar'
    end

    it "is not defined when the value isn't defined by the class" do
      foo = StrictStruct.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.should_not respond_to 'gerard'
    end

    it "raises a NoMethodError when called for a value which isn't defined" do
      foo = StrictStruct.new(:x)
      a_foo = foo.new(x: 3)

      expect do
        a_foo.y
      end.to raise_error NoMethodError
    end
  end

  describe 'immutability' do
    let(:klass) { StrictStruct.new(:x) }

    it "isn't broken by modifiying the input hash" do
      params = {x: 'foo'}
      k = klass.new(params)
      params[:x] = 'bar'

      k.x.should eq 'foo'
    end

    it "isn't broken by modifying output of to_h" do
      k = klass.new(x: 'foo')
      hash = k.to_h
      hash[:x] = 'bar'

      k.x.should eq 'foo'
    end
  end

  describe '#to_h' do
    it "returns all the values the object is defined by" do
      foo = StrictStruct.new(:bar, :baz)

      a_foo = foo.new(bar: 'baz', baz: 3)

      a_foo.to_h.should eq({bar: 'baz', baz: 3})
    end
  end

  describe '#==' do
    it "returns true if the values are the same" do
      foo = StrictStruct.new(:bar)

      a_foo = foo.new(bar: 'baz')
      another_foo = foo.new(bar: 'baz')

      a_foo.should eq another_foo
    end
    it "returns true if the values are the same" do
      foo = StrictStruct.new(:bar)

      a_foo = foo.new(bar: 'baz')
      another_foo = foo.new(bar: 'not_baz')

      a_foo.should_not eq another_foo
    end
  end
end
