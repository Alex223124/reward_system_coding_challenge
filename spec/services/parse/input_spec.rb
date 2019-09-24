require "spec_helper"


RSpec.describe "Input"  do

  context "#with correct data" do

    let(:raw_input) {
                     %{2018-06-12 09:41 A recommends B
                      2018-06-14 09:41 B accepts
                      2018-06-16 09:41 B recommends C
                      2018-06-17 09:41 C accepts
                      2018-06-19 09:41 C recommends D
                      2018-06-23 09:41 B recommends D
                      2018-06-25 09:41 D accepts}
                    }

    let(:formatted_input) {
                            ["2018-06-12 09:41 A recommends B",
                             "                      2018-06-14 09:41 B accepts",
                             "                      2018-06-16 09:41 B recommends C",
                             "                      2018-06-17 09:41 C accepts",
                             "                      2018-06-19 09:41 C recommends D",
                             "                      2018-06-23 09:41 B recommends D",
                             "                      2018-06-25 09:41 D accepts"]
                          }

    before(:each) do
      @input = Services::Parse::Input.new(raw_input)
    end

    describe '#initialize' do

      it 'should initialize correct instance' do
        expect(@input.recommendations).to eq([])
        expect(@input.acceptance_events).to eq([])
        expect(@input.instance_variable_get(:@data)).to eq(raw_input)
      end
    end

    describe '#events' do

      it "should correctly format input data" do
        expect(@input.send(:events)).to eq(formatted_input)
      end
    end

    describe '#sort' do

      context 'when we have acceptance event' do

        let(:acceptance_event) { {:type=>"acceptance", :sender=>"A",
                                  :receiver=>"B", :time=>Time.parse("2018-06-12 09:41:00 +0100")}}

        it "should add event to @acceptance_events" do
          expected_result = [acceptance_event]
          @input.send(:sort, acceptance_event)

          expect(@input.acceptance_events).to eq(expected_result)
        end
      end

      context 'when we have recommendation event' do

        let(:recommendation_event) { {:type=>"recommendation", :sender=>"A",
                                      :receiver=>"B", :time=>Time.parse("2018-06-12 09:41:00 +0100")}}

        it "should add event @recommendations" do
          expected_result = [recommendation_event]
          @input.send(:sort, recommendation_event)

          expect(@input.recommendations).to eq(expected_result)
        end
      end
    end
  end
end