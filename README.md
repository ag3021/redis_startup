# RedisStartup

RedisStartup iterator is an asynchronous nested deferred strategy ideally used for application loading, the flow:

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

(The code above is pseudo code to explain how the Iterator works)

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
