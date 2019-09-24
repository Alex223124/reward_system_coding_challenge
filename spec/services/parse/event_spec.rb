require "spec_helper"


RSpec.describe "Event"  do

  context "#with correct data" do

    let(:recommendation_event) { "2018-06-12 09:41 A recommends B" }
    let(:acceptance_event) { "2018-06-14 09:41 B accepts" }

    before(:each) do
      @event = Services::Parse::Event.new(recommendation_event)
    end

    describe '#initialize' do

      it 'should initialize correct instance' do
        expected_result = ["2018-06-12", "09:41", "A", "recommends", "B"]
        expect(@event.instance_variable_get(:@event)).to eq(expected_result)
      end
    end

    describe '#recommendation' do

      before do
        @event = Services::Parse::Event.new(recommendation_event)
      end

      it 'should return correct hash' do
        expected_result = {:type=>"recommendation", :sender=>"A", :receiver=>"B",
                           :time=> Time.parse("2018-06-12 09:41:00 +0100")}
        expect(@event.send(:recommendation)).to eq(expected_result)
      end
    end

    describe '#acceptance' do

      before do
        @event = Services::Parse::Event.new(acceptance_event)
      end

      it 'should return correct hash' do
        expected_result = {:type=>"acceptance", :sender=>"B",
                           :time=>Time.parse("2018-06-14 09:41:00 +0100")}
        expect(@event.send(:acceptance)).to eq(expected_result)
      end
    end

    describe '#type' do

      context 'when we have acceptance event' do

        before do
          @event = Services::Parse::Event.new(acceptance_event)
        end

        it "should return correct type" do
          expected_result = "acceptance"
          expect(@event.send(:type)).to eq(expected_result)
        end
      end

      context 'when we have recommendation event' do

        before do
          @event = Services::Parse::Event.new(recommendation_event)
        end

        it "should return correct type" do
          expected_result = "recommendation"
          expect(@event.send(:type)).to eq(expected_result)
        end
      end
    end

    describe '#sender' do

      it "should return correct sender" do
        expected_result = "A"
        expect(@event.send(:sender)).to eq(expected_result)
      end
    end

    describe '#receiver' do

      it "should return correct sender" do
        expected_result = "B"
        expect(@event.send(:receiver)).to eq(expected_result)
      end
    end

    describe '#time' do

      it "should return correct sender" do
        expected_result = Time.parse("2018-06-12 09:41:00 +0100")
        expect(@event.send(:time)).to eq(expected_result)
      end
    end
  end
end