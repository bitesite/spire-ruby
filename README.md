# Spire
Spire is a Ruby wrapper around the [Spire Systems API](http://www.spiresystems.com/).

This gem was inspired by [ruby-trello](https://github.com/jeremytregunna/ruby-trello).
If you like this gem, definitely go and check it out.

Additionaly, we want to say thanks to [International Safety Inc.](https://www.internationalsafety.com/) for sponsoring the development of this gem.

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

First you will need to configure spire. This is a global configuration. Thus it will be applied anywhere you use spire within
your application.

If you are using spire within a Rails application, you could put the following config in an initializer.

```ruby
Spire.configure do |config|
  config.company = 'company name'
  config.username = 'username' # Username of a user account within "company name"
  config.password = 'xxxxxxxx' # Password of that user
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

### Customers
Below are a few usage examples. For other uses, please refer to `lib/customer.rb`.

Will retrieve one customer from Spire
```ruby
Spire::Customer.find(customerId)
```

Will search Spire for a customer that matches the given query
```ruby
Spire::Customer.search('casey.li@bitesite.ca')
```

### Vendors
The syntax for vendors is very similar to items. For additional information please refer to `lib/vendor.rb`.

Will retrieve one vendor from Spire
```ruby
Spire::Vendor.find(vendorId)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bitesite/spire.

We do not currently support the entire [Spire](http://www.spiresystems.com/) api.
Any pull requests adding CRUD resources to this gem are appreciated.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
