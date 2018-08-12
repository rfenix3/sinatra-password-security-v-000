require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		erb :signup
	end

	post "/signup" do
		#your code here!
		user = User.new(:username => params[:username], :password => params[:password])
		#binding.pry
		if user.save
	    redirect "/login"
			#binding.pry
	  else
	    redirect "/failure"
			#binding.pry
	  end
	end

	get "/login" do
		erb :login
	end

	post "/login" do
		#your code here!
		user = User.find_by(:username => params[:username])
		binding.pry
		if user && user.authenticate(params[:password])
			session[:id] = user.id
			redirect "/success"
		else
			redirect "/failure"
		end
	end

	get "/success" do
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end

	get "/failure" do
		erb :failure
	end

	get "/logout" do
		sessions.clear
		redirect "/"
	end

	helpers do
		def logged_in?
			!!sessions[:id]
		end

		def current_user
			User.find(sessions[:id])
		end
	end

end
