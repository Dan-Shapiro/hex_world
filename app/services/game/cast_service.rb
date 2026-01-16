module Game
  class CastService
    class CastError < StandardError; end

    def initialize(run:, hex:)
      @run = run
      @hex = hex
    end

    def cast!
      raise CastError, "spell not unlocked" unless unlocked?(hex)

      tags = Array(hex.data["tags"])
      raise CastError, "spell is not castable" unless tags.include?("active")

      effect = hex.data["effect"]
      effect = effect.is_a?(Hash) ? effect.with_indifferent_access : nil
      raise CastError, "no cast effect." if effect.blank? || effect[:timing] != "on_cast"

      Run.transaction do
        Game::EffectResolver.new(run).apply!(effect)
        Game::WinChecker.new(run).check_and_apply!
        Game::LossChecker.new(run).check_and_apply!
        run.save!
      end

      true
    end

    private

    attr_reader :run, :hex

    def unlocked?(h)
      run.run_hexes.exists?(hex_id: h.id)
    end

    def resources_hash
      run.state["resources"] ||= {}
    end

    def ensure_can_pay!(cost)
      cost.each do |k, v|
        next if v.to_i <= 0
        have = resources_hash.fetch(k, 0).to_i
        raise CastError, "not enough #{k} (need #{v}, have #{have})." if have < v.to_i
      end
    end

    def spend!(cost)
      s = run.state.deep_dup
      s["resources"] ||= {}

      cost.each do |k, v|
        next if v.to_i <= 0
        s["resources"][k.to_s] = s["resources"].fetch(k.to_s, 0).to_i - v.to_i
      end

      run.state = s
    end
  end
end
