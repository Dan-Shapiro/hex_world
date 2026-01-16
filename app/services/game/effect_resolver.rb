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

      when "convert_resource"
        from = effect.fetch("from").to_s
        from_amount = effect.fetch("from_amount").to_i
        to = effect.fetch("to").to_s
        to_amount = effect.fetch("to_amount").to_i

        have = run.resources.fetch(from, 0).to_i
        return if have < from_amount

        run.inc_resource!(from, -from_amount)
        run.inc_resource!(to, to_amount)

      else
        # more effects
      end
    end

    private

    attr_reader :run
  end
end
