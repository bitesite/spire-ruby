# Spire-ruby
spire-ruby is a Ruby wrapper around the Spire Systems API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spire'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spire

## Usage

First you will need to configure spire-ruby. This is a global configuration. Thus it will be applied anywhere you use spire-ruby within
your application.

If you are using spire-ruby within a Rails application, you could put the following config in an initializer.

```ruby
Spire.configure do |config|
  config.company = 'company name'
  config.username = 'username' # Username of a user account within "company name"
  config.password = 'xxxxxx' # Password of that user
  config.host = 'example.com' # Location of your Spire server
end
```

### Items
Below are a few usage examples. For other uses, please refer to `lib/item.rb`.

Will retrieve one item from Spire
```ruby
Spire::Item.find(itemId)
```

Will search Spire for an item that matches the given query
```ruby
Spire::Item.search('GF-1234')
```

Will create a new item on Spire
```ruby
Spire::Item.create(options)
```

Will delete an item from Spire
```ruby
Spire::Item.find(itemId).delete
```

Updates item description on Spire
```ruby
item = Spire::Item.find(71)
item.description = 'This is a new description'
item.save
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/spire.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
