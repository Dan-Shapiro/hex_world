class Run < ApplicationRecord
  has_many :run_hexes, dependent: :destroy
  has_many :hexes, through: :run_hexes

  enum :status, { active: 0, won: 1, lost: 2 }

  after_initialize :set_default_state, if: :new_record?

  def resources
    state.fetch("resources", {})
  end

  def set_resources!(key, value)
    s = state.deep_dup
    s["resources"] ||= {}
    s["resources"][key.to_s] = value
    self.state = s
  end

  def inc_resource!(key, amount)
    current = resources.fetch(key.to_s, 0).to_i
    set_resources!(key, current + amount.to_i)
  end

  private

  def set_default_state
    self.state ||= {}
    self.state["resources"] ||= { "essence" => 0, "favor" => 0, "power" => 0 }
    self.state["alignment"] ||= "neutral"
    self.state["threat"] ||= 0
  end
end
