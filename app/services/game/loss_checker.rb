module Game
  class LossChecker
    MAX_THREAT = 10

    def initialize(run)
      @run = run
    end

    def check_and_apply!
      return false unless run.active?

      threat = run.state.fetch("threat", 0).to_i
      return false if threat < MAX_THREAT

      run.status = :lost
      true
    end

    private

    attr_reader :run
  end
end
