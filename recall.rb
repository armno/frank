require "sinatra"
require "data_mapper"
require "rack-flash"
require "sinatra/redirect_with_flash"
enable :sessions
use Rack::Flash, :sweep => true

SITE_TITLE = "Recall"
SITE_DESCRIPTION = "Total Recall"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Note
    include DataMapper::Resource
    property :id, Serial
    property :content, Text, :required => true
    property :complete, Boolean, :required => true, :default => false
    property :created_at, DateTime
    property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

helpers do
    include Rack::Utils
    alias_method :h, :escape_html
end

get '/' do
    @notes = Note.all :order => :id.desc
    @title = "All Notes"

    if @notes.empty?
        flash[:error] = 'No notes'
    end

    erb :home
end

# save new post
post '/' do
    n = Note.new
    n.content = params[:content]
    n.created_at = Time.now
    n.updated_at = Time.now
    n.save
    redirect '/'
end

# RSS feed for notes
get '/rss.xml' do
    @notes = Note.all :order => :id.desc
    builder :rss
end

# editing a note
get '/:id' do
    @note = Note.get params[:id]
    @title = "Edit note ##{params[:id]}"
    erb :edit
end

# save an editing note
put '/:id' do
    n = Note.get params[:id]
    n.content = params[:content]
    n.complete = params[:complete] ? 1 : 0
    n.updated_at = Time.now
    n.save
    redirect '/'
end

# display a delete confirmation page
get '/:id/delete' do
    @note = Note.get params[:id]
    @title = "Confirm to delete the note ##{params[:id]}"
    erb :delete
end

# delete a note
delete '/:id/delete' do
    n = Note.get params[:id]
    n.destroy
    redirect '/'
end

# toggle 'complete' status
get '/:id/complete' do
    n = Note.get params[:id]
    n.complete = n.complete ? 0 : 1
    n.updated_at = Time.now
    n.save
    redirect '/'
end
