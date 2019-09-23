require 'require_all'

ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])


module Services
  module InvitationTrees
  end
  module Parse
    module Recommendations
    end
  end
  module Points
  end
end

require './app/controllers/application_controller'
require_all 'app'