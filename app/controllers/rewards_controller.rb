class RewardsController < ApplicationController

  before do
    content_type 'Content-Type: text/plain'
  end

  helpers do

    def raw_post
      request.body.read
    end

  end

  post '/rewards/calculate' do
    parse_input = Services::Parse::Input.new(raw_post)
    parse_input.perform

    recs = Services::Parse::Recommendations::FilterInvalid.new(parse_input.acceptance_events, parse_input.recommendations).perform

    invitation_tree = Services::InvitationTrees::Create.new(recs)
    invitation_tree.perform

    calculate_service  = Services::Points::Calculate.new(invitation_tree.tree)
    calculate_service.perform

    RewardsPresenter.new(calculate_service.result).as_json
  end

end