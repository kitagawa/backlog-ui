require 'sinatra'
require 'haml'
require 'json'
require './public/backlog_lib'

enable :sessions

get '/login' do
	haml :login, :layout => :layout
end

post '/do_login' do
	session[:username] = params[:username]
	session[:password] = params[:password]
	session[:space_id] = params[:space_id]
	redirect '/'
end

get '/' do
  haml :index, :layout => :layout
end

# プロジェクト一覧取得API
get '/get_projects' do
	client = BacklogLib::Client.new(
		session[:space_id],session[:username],session[:password])
	client.execute("backlog.getProjects").to_json
end
