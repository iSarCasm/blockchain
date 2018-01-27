require 'sinatra'
require 'json'
require_relative 'blockchain'

blockchain = Blockchain.new

post '/add_data' do
  content_type :json
  blockchain.add_data params[:data]
  'Success'
end

get '/last_blocks/:amount', provides: ['html', 'json'] do
  # content_type :json
  blockchain.get_blocks(params[:amount].to_i).to_json
end
