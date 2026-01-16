module Game
  class SpellLibrary
    SPELLS = {
      # economy and crafting
      "spark" => {
        "name" => "Spark",
        "cost" => {},
        "effect" => { "type" => "gain_resource", "resource" => "essence", "amount" => 2, "timing" => "start_of_turn" },
        "tags" => [ "starter", "economy" ]
      },
      "essence_surge" => {
        "name" => "Essence Surge",
        "cost" => {},
        "effect" => { "type" => "gain_resource", "resource" => "essence", "amount" => 8, "timing" => "on_unlock" },
        "tags" => [ "economy" ]
      },
      "air_rune_craft" => {
        "name" => "Craft Air Runes",
        "cost" => { "essence" => 2 },
        "effect" => { "type" => "convert_resource", "from" => "essence", "from_amount" => 1, "to" => "air_rune", "to_amount" => 1, "timing" => "on_cast" },
        "tags" => [ "crafting", "air", "active" ]
      },
      "mind_rune_craft" => {
        "name" => "Craft Mind Runes",
        "cost" => { "essence" => 2 },
        "effect" => { "type" => "convert_resource", "from" => "essence", "from_amount" => 1, "to" => "mind_rune", "to_amount" => 1, "timing" => "on_cast" },
        "tags" => [ "crafting", "mind", "active" ]
      },
      "body_rune_craft" => {
        "name" => "Craft Body Runes",
        "cost" => { "essence" => 3 },
        "effect" => { "type" => "convert_resource", "from" => "essence", "from_amount" => 2, "to" => "body_rune", "to_amount" => 1, "timing" => "on_cast" },
        "tags" => [ "crafting", "body", "active" ]
      },
      "catalytic_focus" => {
        "name" => "Catalytic Focus",
        "cost" => { "essence" => 4 },
        "effect" => { "type" => "gain_resource", "resource" => "essence", "amount" => 1, "timing" => "start_of_turn" },
        "tags" => [ "economy" ]
      },

      # combat / power gain
      "strike" => {
        "name" => "Strike",
        "cost" => {},
        "effect" => {
          "type" => "consume_and_gain",
          "consume" => { "air_rune" => 1, "mind_rune" => 1 },
          "gain" => { "power" => 4 },
          "timing" => "on_cast"
        },
        "tags" => [ "combat", "active" ]
      },
      "bash" => {
        "name" => "Bash",
        "cost" => {},
        "effect" => {
          "type" => "consume_and_gain",
          "consume" => { "body_rune" => 1 },
          "gain" => { "power" => 6 },
          "timing" => "on_cast"
        },
        "tags" => [ "combat", "active" ]
      },
      "channel" => {
        "name" => "Channel",
        "cost" => {},
        "effect" => { "type" => "gain_resource", "resource" => "power", "amount" => 1, "timing" => "start_of_turn" },
        "tags" => [ "combat" ]
      },

      # threat control
      "calm" => {
        "name" => "Calm",
        "cost" => {},
        "cast_cost" => { "essence" => 2 },
        "effect" => { "type" => "change_threat", "amount" => -2, "timing" => "on_cast" },
        "tags" => [ "utility", "active" ]
      },
      "ward" => {
        "name" => "Ward",
        "cost" => {},
        "cast_cost" => { "essence" => 3 },
        "effect" => { "type" => "change_threat", "amount" => -3, "timing" => "on_cast" },
        "tags" => [ "utility", "active" ]
      },
      "recklessness" => {
        "name" => "Recklessness",
        "cost" => {},
        "effect" => {
          "type" => "consume_and_gain",
          "consume" => { "essence" => 3 },
          "gain" => { "power" => 10 },
          "timing" => "on_cast"
        },
        "tags" => [ "combat", "active", "risk" ]
      },

      # god-aligned favor
      "sara_prayer" => {
        "name" => "Saradomin's Prayer",
        "cost" => {},
        "cast_cost" => { "essence" => 2 },
        "effect" => { "type" => "change_threat", "amount" => -2, "timing" => "on_cast" },
        "tags" => [ "sara", "active" ]
      },
      "zam_bloodlust" => {
        "name" => "Zamorak's Bloodlust",
        "cost" => {},
        "effect" => {
          "type" => "consume_and_gain",
          "consume" => { "essence" => 2 },
          "gain" => { "power" => 7 },
          "timing" => "on_cast"
        },
        "tags" => [ "zammy", "active" ]
      },
      "guth_balance" => {
        "name" => "Guthix's Balance",
        "cost" => {},
        "effect" => {
          "type" => "consume_and_gain",
          "consume" => { "power" => 2 },
          "gain" => { "essence" => 5 },
          "timing" => "on_cast"
        },
        "tags" => [ "guthix", "active" ]
      }
    }.freeze

    def self.fetch!(key)
      SPELLS.fetch(key.to_s)
    end

    def self.keys
      SPELLS.keys
    end
  end
end
