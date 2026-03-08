module Telegram
  module Bot
    module RateLimiter
      # Does not apply limit to messages
      class NullAdapter < BaseAdapter
        def initialize(*); end

        def execute(*)
          yield
        end
      end
    end
  end
end