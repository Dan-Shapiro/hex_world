module Game
  class RunEngine
    def initialize(run)
      @run = run
    end

    def end_turn!
      Run.transaction do
        apply_start_of_turn_effects!

        s = run.state.deep_dup
        s["threat"] = s.fetch("threat", 0).to_i + 1
        run.state = s

        Game::WinChecker.new(run).check_and_apply!
        Game::LossChecker.new(run).check_and_apply!

        run.turn = run.turn + 1
        run.save!
      end
    end

    private

    attr_reader :run

    def apply_start_of_turn_effects!
      resolver = Game::EffectResolver.new(run)

      # all unlocked hexes
      run.hexes.find_each do |hex|
        effect = hex.data["effect"]
        next if effect.blank?

        timing = effect["timing"]
        next unless timing == "start_of_turn"

        resolver.apply!(effect)
      end
    end
  end
end
