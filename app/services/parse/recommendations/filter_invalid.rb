class Services::Parse::Recommendations::FilterInvalid

  def initialize(acceptance_events, recommendations)
    @acceptance_events = acceptance_events
    @recommendations = recommendations
    @result = []
  end

  def perform
    @acceptance_events.each do |event|
      @result << valid_rec(rec_for_same_customer(event))
    end
    @result
  end

  private

  def rec_for_same_customer(event)
    @recommendations.find_all { |h| h[:receiver] == event[:sender] }
  end

  def valid_rec(recommendations)
    recommendations.sort_by { |rec| rec[:time] }.first
  end

end