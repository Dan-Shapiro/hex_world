module Game
  class WinChecker
    TARGET_POWER = 40

    def initialize(run)
      @run = run
    end

    def check_and_apply!
      return false unless run.active?

      power = run.resources.fetch("power", 0).to_i
      return false if power < TARGET_POWER

      run.status = :won
      true
    end

    private

    attr_reader :run
  end
end
