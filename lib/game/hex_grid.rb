module Game
  class HexGrid
    # returns axial coords [q, r] for all hexes within radius (inclusive)
    # radius 2 => 19 hexes
    def self.axial_coords(radius:)
      coords = []
      (-radius..radius).each do |q|
        r1 = [ -radius, -q - radius ].max
        r2 = [  radius, -q + radius ].min
        (r1..r2).each do |r|
          coords << [ q, r ]
        end
      end

      coords
    end
  end
end
