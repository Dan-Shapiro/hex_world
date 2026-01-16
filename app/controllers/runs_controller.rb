class RunsController < ApplicationController
  def new
    @alignments = %w[saradomin zamorak guthix]
  end

  def create
    alignment = params[:alignment].to_s
    alignment = "guthix" unless %w[saradomin zamorak guthix].include?(alignment)

    run = Run.create!(
      seed: Random.rand(1_000_000_000),
      status: :active,
      turn: 1,
      state: {
        "resources" => { "essence" => 0, "favor" => 0, "power" => 0, "air_rune" => 0, "mind_rune" => 0 },
        "alignment" => alignment,
        "threat" => 0
      }
    )

    Game::RunSetup.new(run).assign_spellbook!
    center = Hex.find_by!(q: 0, r: 0)
    RunHex.create!(run: run, hex: center, unlocked_at_turn: run.turn)

    redirect_to run_path(run)
  end

  def show
    @run = Run.find(params[:id])
    @hexes = Hex.order(:q, :r).all
    @presenter = Runs::ShowPresenter.new(run: @run, hexes: @hexes)
  end

  def unlock
    run = Run.find(params[:id])
    hex = Hex.find(params[:hex_id])
    spell = run.spell_for(hex)
    return redirect_to run_path(run), alert: "run is #{run.status}" unless run.active?

    Game::UnlockService.new(run: run, hex: hex).unlock!
    redirect_to run_path(run), notice: "unlocked #{spell['name']}"
  rescue Game::UnlockService::UnlockError => e
    redirect_to run_path(run), alert: e.message
  end

  def cast
    run = Run.find(params[:id])
    hex = Hex.find(params[:hex_id])
    spell = run.spell_for(hex)
    return redirect_to run_path(run), alert: "run is #{run.status}" unless run.active?

    Game::CastService.new(run: run, hex: hex).cast!
    redirect_to run_path(run), notice: "cast #{spell['name']}"
  rescue Game::CastService::CastError => e
    redirect_to run_path(run), alert: e.message
  end

  def end_turn
    run = Run.find(params[:id])
    return redirect_to run_path(run), alert: "run is #{run.status}" unless run.active?

    Game::RunEngine.new(run).end_turn!
    redirect_to run_path(run), notice: "turn advanced to #{run.turn}"
  end
end
