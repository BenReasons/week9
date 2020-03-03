# Set up for the application and database. DO NOT CHANGE. ##############
require "sequel"                                                       #
DB = Sequel.connect "sqlite://#{Dir.pwd}/development.sqlite3"          #
########################################################################  

# New domain model - adds users
DB.create_table! :events do
  primary_key :id
  String :title
  String :description, text: true
  String :date
  String :location
end
DB.create_table! :rsvps do
  primary_key :id
  foreign_key :event_id
  foreign_key :user_id
  Boolean :going
  String :comments, text: true
end
DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
events_table = DB.from(:events)

events_table.insert(title: "Bacon Burger Taco Fest", 
                    description: "Here we go again bacon burger taco fans, another Bacon Burger Taco Fest is here!",
                    date: "June 21",
                    location: "Kellogg Global Hub")

events_table.insert(title: "Kaleapolooza", 
                    description: "If you're into nutrition and vitamins and stuff, this is the event for you.",
                    date: "July 4",
                    location: "Nowhere")