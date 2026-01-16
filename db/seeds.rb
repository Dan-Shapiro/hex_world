require_relative "../lib/game/hex_grid"

radius = 2
coords = Game::HexGrid.axial_coords(radius: radius)

# spellbook
SPELLS = [
  # economy and crafting
  {
    key: "spark",
    name: "Spark",
    cost: {},
    effect: { "type" => "gain_resource", "resource" => "essence", "amount" => 2, "timing" => "start_of_turn" },
    tags: [ "starter", "economy" ]
  },
  {
    key: "essence_surge",
    name: "Essence Surge",
    cost: {},
    effect: { "type" => "gain_resource", "resource" => "essence", "amount" => 8, "timing" => "on_unlock" },
    tags: [ "economy" ]
  },
  {
    key: "air_rune_craft",
    name: "Craft Air Runes",
    cost: { "essence" => 2 },
    effect: { "type" => "convert_resource", "from" => "essence", "from_amount" => 1, "to" => "air_rune", "to_amount" => 1, "timing" => "on_cast" },
    tags: [ "crafting", "air", "active" ]
  },
  {
    key: "mind_rune_craft",
    name: "Craft Mind Runes",
    cost: { "essence" => 2 },
    effect: { "type" => "convert_resource", "from" => "essence", "from_amount" => 1, "to" => "mind_rune", "to_amount" => 1, "timing" => "on_cast" },
    tags: [ "crafting", "mind", "active" ]
  },
  {
    key: "body_rune_craft",
    name: "Craft Body Runes",
    cost: { "essence" => 3 },
    effect: { "type" => "convert_resource", "from" => "essence", "from_amount" => 2, "to" => "body_rune", "to_amount" => 1, "timing" => "on_cast" },
    tags: [ "crafting", "body", "active" ]
  },
  {
    key: "catalytic_focus",
    name: "Catalytic Focus",
    cost: { "essence" => 4 },
    effect: { "type" => "gain_resource", "resource" => "essence", "amount" => 1, "timing" => "start_of_turn" },
    tags: [ "economy" ]
  },

  # combat / power gain
  {
    key: "strike",
    name: "Strike",
    cost: {},
    effect: {
      "type" => "consume_and_gain",
      "consume" => { "air_rune" => 1, "mind_rune" => 1 },
      "gain" => { "power" => 4 },
      "timing" => "on_cast"
    },
    tags: [ "combat", "active" ]
  },
  {
    key: "bash",
    name: "Bash",
    cost: {},
    effect: {
      "type" => "consume_and_gain",
      "consume" => { "body_rune" => 1 },
      "gain" => { "power" => 6 },
      "timing" => "on_cast"
    },
    tags: [ "combat", "active" ]
  },
  {
    key: "channel",
    name: "Channel",
    cost: {},
    effect: { "type" => "gain_resource", "resource" => "power", "amount" => 1, "timing" => "start_of_turn" },
    tags: [ "combat" ]
  },

  # threat control
  {
    key: "calm",
    name: "Calm",
    cost: { "essence" => 2 },
    effect: { "type" => "change_threat", "amount" => -2, "timing" => "on_cast" },
    tags: [ "utility", "active" ]
  },
  {
    key: "ward",
    name: "Ward",
    cost: { "essence" => 3 },
    effect: { "type" => "change_threat", "amount" => -3, "timing" => "on_cast" },
    tags: [ "utility", "active" ]
  },
  {
    key: "recklessness",
    name: "Recklessness",
    cost: {},
    effect: {
      "type" => "consume_and_gain",
      "consume" => { "essence" => 3 },
      "gain" => { "power" => 10 },
      "timing" => "on_cast"
    },
    tags: [ "combat", "active", "risk" ]
  },

  # god-aligned favor
  {
    key: "sara_prayer",
    name: "Saradomin's Prayer",
    cost: { "essence" => 3 },
    effect: { "type" => "change_threat", "amount" => -2, "timing" => "on_cast" },
    tags: [ "sara", "active" ]
  },
  {
    key: "zam_bloodlust",
    name: "Zamorak's Bloodlust",
    cost: {},
    effect: {
      "type" => "consume_and_gain",
      "consume" => { "essence" => 2 },
      "gain" => { "power" => 7 },
      "timing" => "on_cast"
    },
    tags: [ "zammy", "active" ]
  },
  {
    key: "guth_balance",
    name: "Guthix's Balance",
    cost: {},
    effect: {
      "type" => "consume_and_gain",
      "consume" => { "power" => 2 },
      "gain" => { "essence" => 5 },
      "timing" => "on_cast"
    },
    tags: [ "guthix", "active" ]
  }
].freeze

# put initial spell in center, then cycle through the rest in the other hexes
center = [ 0, 0 ]
ordered = coords.sort_by { |(q, r)| [ q.abs + r.abs, q, r ] }
ordered.delete(center)
ordered.unshift(center)

ActiveRecord::Base.transaction do
  RunHex.delete_all
  Run.delete_all
  Hex.delete_all

  Hex.transaction do
    ordered.each_with_index do |(q, r), idx|
      spell = if [ q, r ] == center
        SPELLS.first
      else
        SPELLS[1 + ((idx - 1) % (SPELLS.length - 1))]
      end

      Hex.create!(
        q: q,
        r: r,
        spell_key: "#{spell[:key]}_#{q}_#{r}", # unique per tile
        data: {
          "name" => spell[:name],
          "cost" => spell[:cost],
          "effect" => spell[:effect],
          "tags" => spell[:tags]
        }
      )
    end
  end
end

puts "Seeded #{Hex.count} hexes (radius #{radius})"
