require "sinatra/base"

IMAGES = [
	{
		title: "Photo 1",
		url: "http://farm8.staticflickr.com/7287/8738336572_3588e1da15.jpg"
	},
	{
		title: "Photo 2",
		url: "http://farm8.staticflickr.com/7286/8736338425_a703305bbd.jpg"
	},
	{
		title: "Photo 3",
		url: "http://farm8.staticflickr.com/7330/8731315304_def198b68b.jpg" 
	}
]
class App < Sinatra::Base

	before do
		# this block executes AFTER every requests
	end

	after do
		# this block executes AFTER every requests
	end

	before "/images" do
		# this block executes before only "/images" request
	end

	before /test/ do
		# can also be regex
	end

	get "/images" do
		@images = IMAGES
		erb :images
	end

	get "/images/:index" do |index|
		@image = IMAGES[index.to_i]
		haml :"images/view", layout: true
	end

	get '/' do
		"Hello World"
	end

	post '/' do
		"Hello from POST"
	end

	put '/' do
		"Hello via PUT"
	end

	put '/' do
		"Hello via DELETE"
	end

	get '/hello/:name/?:last_name?' do |name, last|
		"Hello #{name} #{last}"
	end
end