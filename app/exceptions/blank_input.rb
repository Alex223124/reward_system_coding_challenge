class BlankInput < StandardError

  EXAMPLE_INPUT_DATA = %{2018-06-12 09:41 A recommends B
                        2018-06-14 09:41 B accepts
                        2018-06-16 09:41 B recommends C
                        2018-06-17 09:41 C accepts
                        2018-06-19 09:41 C recommends D
                        2018-06-23 09:41 B recommends D
                        2018-06-25 09:41 D accepts}

  attr_reader :message

  def initialize(message="Request should contain list of events, example: #{EXAMPLE_INPUT_DATA}")
    @message = message
  end

end