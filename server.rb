require 'sinatra'
require "sinatra/namespace"

namespace '/api/v1' do

  before do
    content_type 'Content-Type: text/plain'
  end

  post '/calculate' do
    # ...
  end

end