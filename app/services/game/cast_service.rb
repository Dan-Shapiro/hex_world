module Game
  class CastService
    class CastError < StandardError; end

    def initialize(run:, hex:)
      @run = run
      @hex = hex
    end

    def cast!
      raise CastError, "spell not unlocked" unless unlocked?(hex)

      spell = run.spell_for(hex)
      raise CastError, "no spell assigned" if spell.blank?

      tags = Array(spell["tags"])
      raise CastError, "spell is not castable" unless tags.include?("active")

      effect = spell["effect"]
      effect = effect.is_a?(Hash) ? effect.with_indifferent_access : nil
      raise CastError, "no cast effect." if effect.blank? || effect[:timing] != "on_cast"

      cast_cost = (spell["cast_cost"] || {}).transform_keys(&:to_s)
      ensure_can_pay!(cast_cost)

      Run.transaction do
        spend!(cast_cost)
        Game::EffectResolver.new(run).apply!(effect)

        if run.state["alignment"].to_s == "zamorak"
          run.inc_resource!("power", 1)
        end

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
