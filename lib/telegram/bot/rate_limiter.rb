module Telegram
  module Bot
    module RateLimiter
      def run
        case Telegram::Bot.configuration.rate_limiter
        in :null | nil
          NullAdapter
        in :async
          AsyncAdapter
        in :thread
          ThreadAdapter
        in Class
          Telegram::Bot.configuration.rate_limiter
        end.new
      end
    end
  end
end
