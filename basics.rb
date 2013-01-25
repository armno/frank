require "rubygems"
require "sinatra"

get '/' do
    "Hello world"
end

get '/about-me' do
    "Little bit about me"
end

get '/hello/:name' do
    "Hello there, #{params[:name].upcase}"
end

get '/more/*' do
    params[:splat]
end

get '/form' do
    erb :form
end

post '/form' do
    "You said #{params[:name]}"
end

# secret method
get '/secret' do
    erb :secret
end

post '/secret' do
    "#{params[:secret].reverse}"
end

#404
not_found do
    halt 404, 'not fooooound'
end