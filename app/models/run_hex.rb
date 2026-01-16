class RunHex < ApplicationRecord
  belongs_to :run
  belongs_to :hex

  validates :unlocked_at_turn, presence: true
end
