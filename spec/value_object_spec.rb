require 'spec_helper'
require 'value_object'

describe 'ValueObject' do
  describe 'initialization' do
    it "works without parameters" do
      foo = ValueObject.new

      a_foo = foo.new

      a_foo.should_not be_nil
    end

    it "works with one parameter" do
      foo = ValueObject.new(:bar)

      a_foo = foo.new(bar: 'baz')

      a_foo.bar.should eq 'baz'
      a_foo.should respond_to 'bar'
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

  describe '#to_h' do
    it "returns all the values the object is defined by" do
      foo = ValueObject.new(:bar, :baz)

      a_foo = foo.new(bar: 'baz', baz: 3)

      a_foo.to_h.should eq({bar: 'baz', baz: 3})
    end
  end

  describe '#==' do
    it "returns true if the values are the same" do
      foo = ValueObject.new(:bar, :baz)

      a_foo = foo.new(bar: 'baz')
      another_foo = foo.new(bar: 'baz')

      a_foo.should eq another_foo
    end
    it "returns true if the values are the same" do
      foo = ValueObject.new(:bar, :baz)

      a_foo = foo.new(bar: 'baz')
      another_foo = foo.new(bar: 'not_baz')

      a_foo.should_not eq another_foo
    end
  end
end
