module Telegram
  module Bot
    class RateLimiter
      def initialize
        klass = case Telegram::Bot.configuration.rate_limiter
                in :null | nil
                  NullAdapter
                in :async
                  AsyncAdapter
                in :thread
                  ThreadAdapter
                in Class
                  Telegram::Bot.configuration.rate_limiter
                end
        
        klass.new
      end
    end
  end
end