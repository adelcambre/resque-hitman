require 'resque/hitman/version'

module Resque
  module Hitman
    module_function

    def activate!
      old_before_fork = Resque.before_fork
      Resque.before_fork = Proc.new do
        if old_before_fork
          old_before_fork.call()
        end
      end
    end
  end
end
