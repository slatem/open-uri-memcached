require 'openuri/common'

begin
  require 'minigems'
rescue LoadError
  require 'rubygems'
end

gem "memcached", ">= 0.10"
require 'memcached'

module OpenURI
  class Cache
    class << self
      # Enable caching
      def enable!
        @cache ||= Memcached::Rails.new(host, {
          :namespace => 'openuri', 
          :no_block => true,
          :buffer_requests => true
        })
        @cache_enabled = true
      end
      
      def get(key)
        @cache.get(key)
      rescue Memcached::NotFound
        false
      end
      
      def set(key, value)
        @cache.set(key, value, expiry)
      end
    end
  end
end