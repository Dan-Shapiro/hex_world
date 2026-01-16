module Game
  class RunEngine
    def initialize(run)
      @run = run
    end

    def end_turn!
      Run.transaction do
        apply_start_of_turn_effects!

        if run.state["alignment"].to_s == "guthix"
          run.inc_resource!("essence", 1)
        end

        s = run.state.deep_dup
        s["threat"] ||= 0

        alignment = s["alignment"].to_s
        turn = run.turn.to_i

        increment =
          if alignment == "saradomin"
            (turn % 2 == 0) ? 1 : 0
          else
            1
          end

        s["threat"] = s.fetch("threat", 0).to_i + increment
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
