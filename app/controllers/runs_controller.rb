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
        "resources" => { "essence" => 0, "favor" => 0, "power" => 0 },
        "alignment" => "neutral"
      }
    )

    redirect_to run_path(run)
  end

  def show
    @run = Run.find(params[:id])
    @hexes = Hex.order(:q, :r).all
  end
end
