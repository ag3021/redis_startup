require 'kim'
require 'yajl/json_gem'
require 'em-hiredis'
require 'redis_startup/version'

class RedisStartup
  PREFIX = 'store_%s'
  MODULE = ->(){}
  def self.data_module(mod)
    suppress_warnings { RedisStartup.const_set(:MODULE, mod) } if mod
  end

  def initialize(client, opts, &blk)
    @client = client
    @log = opts[:log]
    @result_key = opts[:result_key] || 'results'
    @callback = blk
    post_init(opts) unless opts.empty?
  end

  def post_init(opts)
    @close_on_done = opts.delete(:close_on_done)
    EM::Iterator.new(opts).each(proc do |(m, key), iter|
      if(key.is_a?(Array))
	_iter_object(m, key, iter)
      elsif key.is_a?(Hash) && key.key?(:uri)
	_spawn(key, iter)
      else
	_iter_list(m, key, iter)
      end
    end, proc { |*| _try_close; @callback.call if @callback.respond_to?(:call) })
  end

  private

  def _try_close
    @close_on_done && @client.close_connection
  end

  def _spawn(opts, iter)
    new_client = EM::Hiredis.connect(opts.delete(:uri))
    new_client.callback do |*|
      self.class.new(new_client, opts) { |*| iter.next }
    end.errback do |e|
      @log.try(:debug, e)
      iter.next
    end
  end

  def _data_warehouse_method(key, res)
    MODULE.method(format(PREFIX, key).to_sym).call({@result_key => res})
  end

  def _iter_list(m, key, iter)
    @client.lrange(key, 0, -1) do |res|
      _callback(m, res.map { |r| JSON.parse(r) rescue r }, iter)
    end
  end

  def _iter_object(m, key, iter)
    @client.send(*key) do |res|
      if res.is_a?(Array)
	_callback(m, _array_slice_to_hash(res), iter)
      else
	_callback(m, _parse(res), iter)
      end
    end
  end

  def _parse(res)
    JSON.parse(res, symbolize_keys: true) if res
  end

  def _callback(m, res, iter)
    _data_warehouse_method(m, res)
    @log.try(:debug, "Loaded #{m}")
    iter.next
  end

  def _array_slice_to_hash(res)
    res.each_slice(2).with_object({}) do |(k, v), o|
      o.merge!({ (k =~ /^[0-9]+$/ && k || k.to_sym) => _parse(v)})
    end
  end
end
