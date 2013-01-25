require "sinatra"
require "data_mapper"

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

get '/' do
    @notes = Note.all :order => :id.desc
    @title = "All Notes"
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