class Services::Parse::Input

  attr_reader :acceptance_events, :recommendations

  def initialize(data)
    @data = data
    @acceptance_events = []
    @recommendations = []
  end

  def perform
    events.each do |event|
      event = Services::Parse::Event.new(event).perform
      sort(event)
    end
  end

  private

  def events
    @data.split("\n")
  end

  def sort(event)
    event[:type] == "acceptance" ? @acceptance_events << event : @recommendations << event
  end

end