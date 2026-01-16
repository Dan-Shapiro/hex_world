ActiveRecord::Base.transaction do
  # Wipe runs since hex layout/spellbook mapping can change during development
  RunHex.delete_all
  Run.delete_all
  Hex.delete_all

  # Build a radius-2 axial hex grid (center + 18 = 19 total)
  radius = 2
  coords = []

  (-radius..radius).each do |q|
    r1 = [ -radius, -q - radius ].max
    r2 = [  radius, -q + radius ].min
    (r1..r2).each do |r|
      coords << [ q, r ]
    end
  end

  coords.sort_by! { |q, r| [ r, q ] }

  coords.each do |q, r|
    Hex.create!(
      q: q,
      r: r,
      spell_key: "hex_#{q}_#{r}",
      data: {}
    )
  end

  puts "Seeded #{Hex.count} hexes (radius #{radius})."
  center = Hex.find_by(q: 0, r: 0)
  raise "Center hex missing!" unless center
end
