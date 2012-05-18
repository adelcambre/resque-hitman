require 'resque'
require 'resque/hitman'

class HitmanJob
  @queue = :test
  @runs = []

  def self.perform(param = "sample")
    @runs << param
  end
end

describe Resque::Hitman do
  after do
    Resque::Hitman.deactivate!
  end

  context "not-activated" do
    it "doesn't add a before_fork hook" do
      Resque.before_fork.should be_nil
    end

    it "calls the previously registered before_fork hook" do
      $hook_called = false
      Resque.before_fork = Proc.new { $hook_called = true }
      Resque::Hitman.activate!

      Resque.enqueue(HitmanJob)

      worker = Resque::Worker.new("*")
      worker.work(0)

      $hook_called.should be_true
    end
  end

  context "activated" do
    before do
      Resque::Hitman.activate!
    end

    it "adds a before_fork hook" do
      Resque.before_fork.should_not be_nil
    end
  end
end
