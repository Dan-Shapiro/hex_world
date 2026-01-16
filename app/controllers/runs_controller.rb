require "set"

class RunsController < ApplicationController
  def new
    # start screen
  end

  def create
    run = Run.create!(
      seed: Random.rand(1_000_000_000),
      status: :active,
      turn: 1,
      state: {
        "resources" => { "essence" => 0, "favor" => 0, "power" => 0, "air_rune" => 0, "mind_rune" => 0 },
        "alignment" => "neutral"
      }
    )

    center = Hex.find_by!(q: 0, r: 0)
    RunHex.create!(run: run, hex: center, unlocked_at_turn: run.turn)

    redirect_to run_path(run)
  end

  def show
    @run = Run.find(params[:id])
    @hexes = Hex.order(:q, :r).all
    @unlocked_hex_ids = @run.run_hexes.pluck(:hex_id).to_set
  end

  def unlock
    @run = Run.find(params[:id])
    hex = Hex.find(params[:hex_id])

    Game::UnlockService.new(run: @run, hex: hex).unlock!
    redirect_to run_path(@run), notice: "unlocked #{hex.data['name']}"
  rescue Game::UnlockService::UnlockError => e
    redirect_to run_path(@run), alert: e.message
  end

  def end_turn
    run = Run.find(params[:id])

    Game::RunEngine.new(run).end_turn!
    redirect_to run_path(run), notice: "turn advanced to #{run.turn}"
  end
end
