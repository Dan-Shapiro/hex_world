module RunsHelper
  def format_cost(cost_hash, effect: nil)
    # 1) explicit cost hash
    if cost_hash.present?
      formatted = cost_hash
        .select { |_k, v| v.to_i > 0 }
        .map { |k, v| "#{k}: #{v}" }
        .join(", ")
      return formatted.presence || "free"
    end

    # 2) infer from effect (cast costs)
    return "free" unless effect.is_a?(Hash)

    effect = effect.with_indifferent_access

    case effect[:type]
    when "convert_resource"
      from = effect[:from].to_s
      amt = effect[:from_amount].to_i
      return amt.positive? ? "#{from}: #{amt}" : "free"

    when "consume_and_gain"
      consume = (effect[:consume] || {}).to_h
      formatted = consume
        .select { |_k, v| v.to_i > 0 }
        .map { |k, v| "#{k}: #{v}" }
        .join(", ")
      return formatted.presence || "free"
    end

    "free"
  end
end
