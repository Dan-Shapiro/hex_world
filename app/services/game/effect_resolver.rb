module Game
  class EffectResolver
    def initialize(run)
      @run = run
    end

    def apply!(effect)
      type = effect["type"]

      case type
      when "gain_resource"
        resource = effect.fetch("resource")
        amount = effect.fetch("amount").to_i
        run.inc_resource!(resource, amount)
      else
        # more effects
      end
    end

    private

    attr_reader :run
  end
end
