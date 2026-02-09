module Telegram
  module Bot
    module RateLimiter
      class NullAdapter < BaseAdapter
        def initialize(*); end

        def execute(*)
          yield
        end
      end
    end
  end
end