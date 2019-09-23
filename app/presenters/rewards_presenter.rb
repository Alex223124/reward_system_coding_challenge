class RewardsPresenter < Presenter

  def as_json(*)
    format_values(merge_results).to_json
  end

  private

  def merge_results
    @object.inject(:merge)
  end

  def format_values(h)
    h.transform_values! { |v| v.to_s("F") }
  end

end