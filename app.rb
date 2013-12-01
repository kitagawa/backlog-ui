require 'sinatra'
require 'haml'
require 'json'
require './public/backlog_lib'

enable :sessions

# ログイン画面
get '/login' do
	haml :login, :layout => :layout
end

# ログイン処理
post '/do_login' do
	session[:username] = params[:username]
	session[:password] = params[:password]
	session[:space_id] = params[:space_id]
	redirect '/projects'
end

# プロジェクト選択
get '/projects' do
	haml :projects, :layout => :layout
end

#プロジェクト内バージョン一覧
get '/projects/:id' do

  haml :versions, :layout => :layout
end

# プロジェクト一覧取得API
get '/get_projects' do
	client.execute("backlog.getProjects").to_json
end

# プロジェクト一覧取得API
get '/get_versions/:projectId' do
	client.execute("backlog.getVersions",params[:projectId].to_i).to_json
end

# Backlog接続クライアント取得
def client
	BacklogLib::Client.new(
		session[:space_id],session[:username],session[:password])
end