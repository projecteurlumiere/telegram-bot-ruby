# frozen_string_literal: true

module Telegram
  module Bot
    class Configuration
      attr_accessor :adapter, :connection_open_timeout, :connection_timeout,
                    :rate_limiter, :user_rate_interval, :group_rate_interval

      def initialize
        @adapter = Faraday.default_adapter
        @connection_open_timeout = 20
        @connection_timeout = 20

        @rate_limiter        = :null
        @user_rate_interval  = 1.0 / 30 # 30 messages per second
        @group_rate_interval = 4        # 20 messages per minute
      end
    end
  end
end
