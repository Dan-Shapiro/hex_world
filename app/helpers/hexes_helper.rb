module HexesHelper
  # Returns up to 2 lines, already truncated nicely.
  def hex_label_lines(name, max_chars_per_line: 9)
    s = name.to_s.strip
    return [ "???" ] if s.empty?

    # Prefer splitting on spaces into 1–2 lines
    words = s.split(/\s+/)
    if words.length > 1
      line1 = +""
      line2 = +""

      words.each do |w|
        if line2.empty?
          # Fill line1 first
          if (line1.empty? ? w : "#{line1} #{w}").length <= max_chars_per_line
            line1 = (line1.empty? ? w : "#{line1} #{w}")
          else
            line2 = w
          end
        else
          # Fill line2
          candidate = "#{line2} #{w}"
          break if candidate.length > max_chars_per_line
          line2 = candidate
        end
      end

      # If we couldn't fit everything, truncate line2
      if (line1 + " " + line2).strip.length < s.length
        line2 = truncate_for_hex(line2, max_chars_per_line)
      end

      return [ line1, line2 ].reject(&:empty?)
    end

    # Single long word: prefer truncation over awkward splits
    if s.length > max_chars_per_line
      [ truncate_for_hex(s, max_chars_per_line) ]
    else
      [ s ]
    end
  end

  def hex_font_size(name)
    len = name.to_s.length
    return 12 if len <= 6
    return 11 if len <= 12
    return 10 if len <= 18
    9
  end

  private

  def truncate_for_hex(s, max_chars)
    s = s.to_s
    return s if s.length <= max_chars
    # leave room for ellipsis
    cutoff = [ max_chars - 1, 1 ].max
    "#{s[0, cutoff]}…"
  end
end
