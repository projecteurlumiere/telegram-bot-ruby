# frozen_string_literal: true

module Telegram
  module Bot
    module RateLimiter
      class AsyncAdapter < BaseAdapter
        class SchedulerMissingError < StandardError

        def initialize(...)
          require 'async/notification'

          @queues = Hash.new { |hash, key| hash[key] = [] }
          @new_jobs = []
          @job_available = Async::Notification.new

          super
        end

        def stop
          @job_available.signal

          super
        end

        private

        def enqueue(id)
          if @running
            job_start = Async::Notification.new
            @new_jobs << [id, job_start]
            @job_available.signal
            job_start.wait
          end
        end

        def process_jobs
          verify_async!

          Async do
            while @running
              @job_available.wait if @queues.none?

              iterate
            end

            iterate until @queues.none?
            LOGGER.debug "Gracefully shut down RateLimiter"
          end
        end

        def iterate
          while @new_jobs.shift in [id, job_start]
            @queues[id] << [job_start]
          end

          @queues.reject! do |_id, jobs|
            next true unless jobs.shift in [job_start]

            job_start.signal

            sleep(@interval)
            false
          end
        end

        def verify_async!
          raise SchedulerMissingError "Async gem is missing"     unless defined? Async::Task
          raise SchedulerMissingError "Async reactor is missing" unless Async::Task.current?
        end
      end
    end
  end
end