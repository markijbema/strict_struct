# StrictStruct [![Build Status](https://travis-ci.org/markijbema/strict_struct.png)](https://travis-ci.org/markijbema/strict_struct) [![Code Climate](https://codeclimate.com/github/markijbema/strict_struct.png)](https://codeclimate.com/github/markijbema/strict_struct) [![Gem Version](https://badge.fury.io/rb/strict_struct.png)](http://badge.fury.io/rb/strict_struct) [![Dependency Status](https://gemnasium.com/markijbema/strict_struct.png)](https://gemnasium.com/markijbema/strict_struct)

This gems aims to provide a modern version of Struct.
While Struct is a nice easy way to create a light-weight
value object, it has some drawbacks

* You need to remember the order of arguments
* The object is mutable by default

This gem aims to avoid these drawbacks, while providing the
ease of use of Struct.

## Usage

If you want to create a simple object, just declare it like
you would declare a Struct:

```ruby
Rectangle = StrictStruct.new(:x, :y) do
  def area
    x * y
  end
end
```

This would conceptually create something like the following object:

```ruby
class Rectange
  attr_reader :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end

  def to_h
    to_h
  end

  def to_hash
    {
      x: x,
      y: y
    }
  end

  def area
    x * y
  end
end
```

Since this is meant to create immutable objects, the values aren't actually assigned to instance variables but safed internally in a hash.

### Changing behaviour

You can also choose to override behaviour. You can just use super in the initialization block like you are used to with normal classes:

```ruby
Rectangle = StrictStruct.new(:x, :y) do
  def area
    x * y
  end

  def to_hash
    super.merge({area: area})
  end
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'strict_struct'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strict_struct


TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
