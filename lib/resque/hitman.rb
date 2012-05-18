require 'resque/hitman/version'

module Resque
  module Hitman
    module_function

    def activate!(interval=5.0)
      @interval = Float(interval)
      old_before_fork = Resque.before_fork
      Resque.before_fork = Proc.new do |job|
        $hitman_monitor_thread ||= monitor(job.worker)
        if old_before_fork
          old_before_fork.call()
        end
      end
    end

    def deactivate!
      Resque.before_fork = nil
      if $hitman_monitor_thread
        $hitman_monitor_thread.kill
        $hitman_monitor_thread = nil
      end
    end

    def kill!(worker)
      id = if worker.respond_to?(:job)
             worker.id
           else
             worker
           end
      set(key(id), 1)
    end

    def key(worker_id)
      "resque:hitman:kill:#{worker_id}"
    end

    def check(worker)
      unless redis.del(key(worker.id)) == 0
        worker.kill_child
      end
    end

    def monitor(worker)
      Thread.new do
        loop do
          check(worker)
          sleep @interval
        end
      end
    end

    def redis
      Resque.redis
    end
  end
end
