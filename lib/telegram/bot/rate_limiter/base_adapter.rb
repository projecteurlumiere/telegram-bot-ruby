# frozen_string_literal: true

require 'async/notification'

module Telegram
  module Bot
    module RateLimiter
      class BaseAdapter
        attr_reader :user_interval, :group_interval

        def initialize
          @user_interval  = Telegram::Bot.configuration.user_rate_interval
          @group_interval = Telegram::Bot.configuration.group_rate_interval
          @running        = true

          [user_interval, group_interval].each do |interval|
            process_jobs
          end
        end

        def execute(params)
          id = id_from_params(params)
          enqueue(id) unless id.nil?

          yield
        end

        def stop
          @running = false
        end

        private

        def id_from_params(params)
          chat_id = params[:chat_id]

          if chat_id&.negative? # group chat
            [
              chat_id,
              params.fetch(:message_thread_id, 0)
            ].join('_')
          else
            chat_id
          end
        end

        def enqueue(_id)
          raise "Method `#{__method__}` must be defined in the child class"
        end

        def process_jobs
          raise "Method `#{__method__}` must be defined in the child class"
        end
      end
    end
  end
end
