module Game
  class RunEngine
    def initialize(run)
      @run
    end

    def end_turn!
      # apply passive effects, increment turn, save state
      raise NotImplementedError
    end

    private

    attr_reader :run
  end
end
