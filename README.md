# RedisStartup

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/redis_startup`. To experiment with that code, run `bin/console` for an interactive prompt.

RedisStartup iterator is a nested deferred strategy ideally used for application loading, the flow:

```code
  client = Redis.new
  opts = {
    method: load_data
    method1: load_data1
    method2: [hgetall, load_data2]
  }

  RedisStartup.new(client, opts) on_finish = { p 'FINISH' }

  goto method
  lrange(load_data, 0, -1).callback (res) -> store_method(res) -> goto next (method1)
  lrange(load_data1, 0, -1).callback (res) -> store_method1(res) -> goto next (method2)
  hgetall(load_data2).callback (res) -> store_method2(res) -> goto next (nothing, finish)
  finished (goto on_finish)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_startup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_startup

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/redis_startup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.