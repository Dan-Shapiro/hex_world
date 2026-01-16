require_relative "../lib/game/hex_grid"

radius = 2
coords = Game::HexGrid.axial_coords(radius: radius)

# spellbook
SPELLS = [
  {
    key: "spark",
    name: "Spark",
    cost: {},
    effect: { "type" => "gain_resource", "resource" => "essence", "amount" => 2, "timing" => "start_of_turn" },
    tags: [ "starter", "economy" ]
  },
  {
    key: "essence_tap",
    name: "Essence Tap",
    cost: {},
    effect: { "type" => "gain_resource", "resource" => "essence", "amount" => 5, "timing" => "on_unlock" },
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
    key: "strike",
    name: "Strike",
    cost: {},
    effect: { "type" => "consume_and_gain", "consume" => { "air_rune" => 1, "mind_rune" => 1 }, "gain" => { "power" => 4 }, "timing" => "on_cast" },
    tags: [ "combat", "active" ]
  },
  {
    key: "focus",
    name: "Focus",
    cost: { "essence" => 4 },
    effect: { "type" => "discount_unlock", "resource" => "essence", "amount" => 1 },
    tags: [ "utility" ]
  },
  {
    key: "sara_grace",
    name: "Saradomin's Grace",
    cost: { "essence" => 5 },
    effect: { "type" => "gain_resource", "resource" => "favor", "amount" => 1, "timing" => "start_of_turn", "alignment" => "saradomin" },
    tags: [ "sara", "alignment" ]
  },
  {
    key: "zam_fury",
    name: "Zamorak's Fury",
    cost: { "essence" => 5 },
    effect: { "type" => "gain_resource", "resource" => "power", "amount" => 2, "timing" => "start_of_turn", "alignment" => "zamorak" },
    tags: [ "zammy", "alignment" ]
  },
  {
    key: "guthix_balance",
    name: "Guthix's Balance",
    cost: { "essence" => 5 },
    effect: { "type" => "convert_resource", "from" => "favor", "from_amount" => 1, "to" => "essence", "to_amount" => 2, "timing" => "start_of_turn", "alignment" => "guthix" },
    tags: [ "guthix", "alignment" ]
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
