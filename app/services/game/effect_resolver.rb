module Game
  class EffectResolver
    def initialize(run)
      @run = run
    end

    def apply!(effect)
      # interpret effect json and mutate run state
      raise NotImplementedError
    end

    private

    attr_reader :run
  end
end
