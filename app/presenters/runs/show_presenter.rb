require "set"

module Runs
  class ShowPresenter
    attr_reader :run, :hexes

    SIZE = 42.0
    SQRT3 = Math.sqrt(3)

    def initialize(run:, hexes:)
      @run = run
      @hexes = hexes
      @unlocked_hex_ids = run.run_hexes.pluck(:hex_id).to_set
      @hex_id_by_coord = hexes.index_by { |h| [ h.q, h.r ] }.transform_values(&:id)
    end

    def active?
      run.active?
    end

    def unlocked?(hex)
      @unlocked_hex_ids.include?(hex.id)
    end

    def available?(hex)
      return false if unlocked?(hex)
      hex.neighbors.any? do |q, r|
        nid = @hex_id_by_coord[[ q, r ]]
        nid && @unlocked_hex_ids.include?(nid)
      end
    end

    def affordable_unlock?(hex)
      spell = @run.spell_for(hex)
      cost = (spell["cost"] || {})
      cost.all? do |k, v|
        v.to_i <= 0 || run.resources.fetch(k.to_s, 0).to_i >= v.to_i
      end
    end

    def center_px(hex)
      q = hex.q
      r = hex.r
      x = SIZE * SQRT3 * (q + r / 2.0)
      y = SIZE * 1.5 * r
      [ x, y ]
    end

    def hex_points(cx, cy)
      (0..5).map do |i|
        angle = (Math::PI / 180.0) * (60 * i - 30)
        px = cx + SIZE * Math.cos(angle)
        py = cy + SIZE * Math.sin(angle)
        "#{px.round(2)},#{py.round(2)}"
      end.join(" ")
    end

    def view_box
      centers = hexes.map { |h| center_px(h) }
      xs = centers.map(&:first)
      ys = centers.map(&:last)

      padding = SIZE * 2.2
      min_x = xs.min - padding
      max_x = xs.max + padding
      min_y = ys.min - padding
      max_y = ys.max + padding

      view_w = (max_x - min_x)
      view_h = (max_y - min_y)

      [ min_x, min_y, view_w, view_h ].map { |n| n.round(2) }.join(" ")
    end

    def style_for(hex)
      is_unlocked = unlocked?(hex)
      is_available = available?(hex)
      affordable = affordable_unlock?(hex)

      fill =
        if is_unlocked
          "#e8f5ff"
        elsif is_available && affordable
          "#fff8e1"
        elsif is_available && !affordable
          "#fff3e0"
        else
          "#f3f3f3"
        end

      stroke =
        if is_unlocked
          "#1976d2"
        elsif is_available && affordable
          "#f57c00"
        elsif is_available && !affordable
          "#d32f2f"
        else
          "#999"
        end

      { fill: fill, stroke: stroke }
    end
  end
end
