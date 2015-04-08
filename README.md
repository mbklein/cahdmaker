# Cahdmaker

Create card images for use with a [party game for horrible people](http://cardsagainsthumanity.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cahdmaker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cahdmaker

## Usage

### Code

```ruby
require 'cahdmaker'

maker = Cahdmaker::Maker.new()

# Generate in-memory card images as RMagick Magick::Image objects
white_card = maker.white("31 flavors of hate")
black_card = maker.black("I would have gotten away with it if it weren't for _.")
pick2_card = maker.black2("I would have gotten away with _ if it weren't for _.")
pick3_card = maker.black3("I would have gotten away with _ if it weren't for _ and _.")

# Save image to file
white_card.write('/path/to/white_card.png')

# Grab image PNG data
data = white_card.to_blob

# Block-driven
maker.white('31 flavors of hate') { |card| card.write('/path/to/white_card.png') }
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cahdmaker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
