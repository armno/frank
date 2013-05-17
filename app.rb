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

	enable :session, :logging # to be able to access session functionality
	disable :show_exeptions
	register Sinatra::Namespace

	configure do
		set :envirionment, ENV["RACK_ENV"]
		:logging
		# enable :logging
		# disable :logging
		# set :public_folder, "assets"
		enable :raise_errors
	end

	configure :development do

	end

	configure :production do

	end

	not_found do
		# called when 404 is raised
		haml :"404", layout: true
	end
	 
	error do
		haml :error, layout: true, layout_engine: :erb
	end

	get "/500" do
		raise StandardError, "Intentional fucking up"
	end
	
	error 403 do
		# what to be done only if 403 raised
		"Forbidden. Go home!"
	end

	get "/403" do
		halt 403
	end

	before do
		# this block executes AFTER every requests
		@name = session[:name] # read value from session and set it to an instance var

		logger = Log4r::Logger["app"]
		logger.info "This is an info message"
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
		session[:name] = "ArmNo" # set a value into session
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

	namespace "/images" do
		get do
			@images = Image.all
			haml :"/images/index", layout_engine: :erb
		end
	end
end
