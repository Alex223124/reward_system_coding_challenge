require "spec_helper"

RSpec.describe "FilterInvalid"  do

  context "#with correct data" do

    let(:acceptance_events) {
                              [{:type=>"acceptance", :sender=>"B", :time=>Time.parse("2018-06-14 09:41:00 +0100")},
                               {:type=>"acceptance", :sender=>"C", :time=>Time.parse("2018-06-17 09:41:00 +0100")},
                               {:type=>"acceptance", :sender=>"D", :time=>Time.parse("2018-06-25 09:41:00 +0100")}]
                            }

    let(:recommendations) {
                            [{:type=>"recommendation", :sender=>"A", :receiver=>"B",
                              :time=>Time.parse("2018-06-12 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"B", :receiver=>"C",
                             :time=>Time.parse("2018-06-16 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"C", :receiver=>"D",
                             :time=>Time.parse("2018-06-19 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"O", :receiver=>"C",
                             :time=>Time.parse("2018-06-19 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"P", :receiver=>"C",
                             :time=>Time.parse("2018-06-19 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"B", :receiver=>"D",
                             :time=>Time.parse("2018-06-23 09:41:00 +0100")}]
                          }

    before(:each) do
      @filter = Services::Parse::Recommendations::FilterInvalid.new(acceptance_events, recommendations)
    end

    describe '#initialize' do

      it 'should initialize correct instance' do
        expect(@filter.instance_variable_get(:@acceptance_events)).to eq(acceptance_events)
        expect(@filter.instance_variable_get(:@recommendations)).to eq(recommendations)
      end
    end

    describe '#rec_for_same_customer' do

      let(:event) { {:type=>"acceptance", :sender=>"C", :time=>Time.parse("2018-06-17 09:41:00 +0100") } }

      it 'should find all records for specific customer using receiver field' do
        expected_result = [{:type=>"recommendation", :sender=>"B", :receiver=>"C",
                            :time=>Time.parse("2018-06-16 09:41:00 +0100")},
                           {:type=>"recommendation", :sender=>"O", :receiver=>"C",
                            :time=>Time.parse("2018-06-19 09:41:00 +0100")},
                           {:type=>"recommendation", :sender=>"P", :receiver=>"C",
                            :time=>Time.parse("2018-06-19 09:41:00 +0100")}]
        expect(@filter.send(:rec_for_same_customer, event)).to eq(expected_result)
      end
    end

    describe '#valid_rec' do

      let(:recommendations) {
                              [{:type=>"recommendation", :sender=>"B", :receiver=>"C",
                                :time=>Time.parse("2018-06-16 09:41:00 +0100")},
                               {:type=>"recommendation", :sender=>"O", :receiver=>"C",
                                :time=>Time.parse("2018-06-19 09:41:00 +0100")},
                               {:type=>"recommendation", :sender=>"P", :receiver=>"C",
                                :time=>Time.parse("2018-06-19 09:41:00 +0100")}]
                            }
      let(:event) { {:type=>"acceptance", :sender=>"C", :time=>Time.parse("2018-06-17 09:41:00 +0100") } }

      it 'should pick first recommendation by time' do
        expected_result = {:type=>"recommendation", :sender=>"B", :receiver=>"C",
                           :time=>Time.parse("2018-06-16 09:41:00 +0100")}
        expect(@filter.send(:valid_rec, recommendations)).to eq(expected_result)
      end
    end
  end
end