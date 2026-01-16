require "set"

module Game
  class UnlockService
    class UnlockError < StandardError; end

    def initialize(run:, hex:)
      @run = run
      @hex = hex
    end

    def unlock!
      raise UnlockError, "already unlocked" if unlocked?(hex)
      raise UnlockError, "not adjacent to an unlocked hex" unless adjacent_to_unlocked?(hex)

      cost = (hex.data["cost"] || {}).transform_keys(&:to_s)
      ensure_can_pay!(cost)

      Run.transaction do
        spend!(cost)
        RunHex.create!(run: run, hex: hex, unlocked_at_turn: run.turn)

        effect = hex.data["effect"]
        effect = effect.is_a?(Hash) ? effect.with_indifferent_access : nil
        if effect.present? && effect[:timing] == "on_unlock"
          Game::EffectResolver.new(run).apply!(effect)
        end

        run.save!
      end

      true
    end

    private

    attr_reader :run, :hex

    def unlocked?(h)
      run.run_hexes.exists?(hex_id: h.id)
    end

    def adjacent_to_unlocked?(h)
      unlocked_coords = run.hexes.pluck(:q, :r).to_set
      h.neighbors.any? { |q, r| unlocked_coords.include?([ q, r ]) }
    end

    def resources_hash
      run.state["resources"] ||= {}
    end

    def ensure_can_pay!(cost)
      cost.each do |k, v|
        next if v.to_i <= 0
        have = resources_hash.fetch(k, 0).to_i
        raise UnlockError, "not enough #{k} (need #{v}, have #{have})" if have < v.to_i
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
