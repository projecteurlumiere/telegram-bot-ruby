# frozen_string_literal: true
module Telegram
  module Bot
    module RateLimiter
      class ThreadAdapter < BaseAdapter
        def initialize(...)
          require 'concurrent/array'
          require 'concurrent/event'

          @queues = Hash.new { |hash, key| hash[key] = [] }
          @new_jobs = Concurrent::Array.new
          @job_available = Concurrent::Event.new

          super
        end

        def execute(id)
          if @running
            job_start = Concurrent::Event.new
            @new_jobs << [id, job_start]
            @job_available.signal
            job_start.wait
          end

          yield
        end

        def stop
          @running = false
          @job_available.signal
        end

        private

        def process_jobs
          Thread.new do
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
      end
    end
  end
end