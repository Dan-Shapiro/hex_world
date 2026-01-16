module Game
  class UnlockService
    def initialize(run:, hex:)
      @run = run
      @hex = hex
    end

    def unlock!
      # validate adjacency, check cost, persist RunHex, apply unlock effects
      raise NotImplementedError
    end

    private

    attr_reader :run, :hex
  end
end
