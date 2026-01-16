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
        from = effect.fetch(:from).to_s
        from_amount = effect.fetch(:from_amount).to_i
        to = effect.fetch(:to).to_s
        to_amount = effect.fetch(:to_amount).to_i

        have = run.resources.fetch(from, 0).to_i
        return if have < from_amount

        run.inc_resource!(from, -from_amount)
        run.inc_resource!(to, to_amount)

      when "consume_and_gain"
        consume = (effect[:consume] || {}).to_h.transform_keys(&:to_s)
        gain = (effect[:gain] || {}).to_h.transform_keys(&:to_s)

        can_pay = consume.all? do |k, v|
          v.to_i <= 0 || run.resources.fetch(k, 0).to_i >= v.to_i
        end
        return unless can_pay

        consume.each { |k, v| run.inc_resource!(k, -v.to_i) }
        gain.each { |k, v| run.inc_resource!(k, v.to_i) }

      else
        # more effects
      end
    end

    private

    attr_reader :run
  end
end
