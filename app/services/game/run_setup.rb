module Game
  class RunSetup
    def initialize(run)
      @run = run
    end

    def assign_spellbook!
      hexes = Hex.order(:q, :r).to_a
      center = hexes.find { |h| h.q == 0 && h.r == 0 }
      raise "center hex not found" unless center

      rng = Random.new(run.seed.to_i)

      # Always keep Spark at the center
      pool = Game::SpellLibrary.keys - [ "spark" ]
      pool = pool.shuffle(random: rng)

      assignments = {}
      assignments[center.id.to_s] = "spark"

      # Fill remaining tiles. If not enough unique spells, cycle.
      i = 0
      (hexes - [ center ]).each do |hex|
        assignments[hex.id.to_s] = pool[i % pool.length]
        i += 1
      end

      s = run.state.deep_dup
      s["spellbook"] = assignments
      run.state = s
      run.save!
    end

    private

    attr_reader :run
  end
end
