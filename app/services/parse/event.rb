class Services::Parse::Event

  DATE_INDEX = 0
  TIME_INDEX = 1
  SENDER_INDEX = 2
  RECEIVER_INDEX = 4

  def initialize(event)
    @event = event.split(" ")
  end

  def perform
    if type == "acceptance"
      acceptance
    else
      recommendation
    end
  end

  private

  def recommendation
    {
        type: "recommendation",
        sender: sender,
        receiver: receiver,
        time: time
    }
  end

  def acceptance
    {
        type: "acceptance",
        sender: sender,
        time: time
    }
  end

  def type
    @event.last == "accepts" ? "acceptance" : "recommendation"
  end

  def sender
    @event[SENDER_INDEX]
  end

  def receiver
    @event[RECEIVER_INDEX]
  end

  def time
    Time.parse("#{@event[DATE_INDEX]} #{@event[TIME_INDEX]}")
  end

end