require 'sinatra'
require "sinatra/namespace"
require 'pry'

namespace '/api/v1' do

  before do
    content_type 'Content-Type: text/plain'
  end

  helpers do

    def raw_post
      request.body.read
    end

  end

  post '/calculate' do
    a = raw_post
  end

end