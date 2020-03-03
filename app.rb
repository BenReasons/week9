# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"  
require "sinatra/cookies"                                                             #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "bcrypt"                                                                      #
require "twilio-ruby"                                                                 #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

events_table = DB.from(:events)
rsvps_table = DB.from(:rsvps)

get "/" do
    puts events_table.all
    @events = events_table.all.to_a
    view "events"
end

get "/events/:id" do
    @event = events_table.where(id: params[:id]).to_a[0]
    @rsvps = rsvps_table.where(event_id: @event[:id])
    @going_count = rsvps_table.where(event_id: @event[:id]).sum(:going)
    view "event"
end

get "/events/:id/rsvps/new" do
    @event = events_table.where(id: params[:id]).to_a[0]
    view "new_rsvp"
end

get "/events/:id/rsvps/create" do
    puts params
    @event = events_table.where(id: params[:id]).to_a[0]
    rsvps_table.insert(event_id: params["id"],
                        going: params["going"],
                        name: params["name"],
                        email: params["email"],
                        comments: params["comments"])
    view "create_rsvp"
end

get "/users/new" do
    view "new_user"
end

get "/users/create" do
    puts params
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

get "/logins/create" do
    puts params
    view "create_login"
end

get "/logout" do
    view "logout"
end