# app.rb
require "sinatra"
require "sinatra/activerecord"
require "./models/items"

class HelloWorld < Sinatra::Base
  # Home page
  get "/" do
    erb :index
  end
  
  # Create
  post "/create" do
    # Workaround for ActiveRecord loosing the pkey index
    ActiveRecord::Base.connection.reset_pk_sequence!("items")
    @item = Items.new(params[:item])
      if @item.save
        redirect "/read"
      else
        "ERROR: Something went wrong while saving your record!"
      end
   end

  get "/read" do
    @items = Items.all
    erb :get_items
  end

end
