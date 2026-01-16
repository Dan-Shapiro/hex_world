module RunsHelper
  def format_cost(cost_hash)
    cost_hash ||= {}
    cost_hash
      .select { |_k, v| v.to_i > 0 }
      .map { |k, v| "#{k}: #{v}" }
      .join(", ")
      .presence || "free"
  end
end
