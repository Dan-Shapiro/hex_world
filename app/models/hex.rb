class Hex < ApplicationRecord
  has_many :run_hexes, dependent: :destroy
  has_many :runs, through: :run_hexes

  validates :q, :r, :spell_key, presence: true

  # axial neighbors
  NEIGHBOR_DELTAS = [
    [ 1,  0 ],
    [ 1, -1 ],
    [ 0, -1 ],
    [ -1,  0 ],
    [ -1,  1 ],
    [ 0,  1 ]
  ].freeze

  def neighbors
    NEIGHBOR_DELTAS.map do |dq, dr|
      [ q + dq, r + dr ]
    end
  end
end
