require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require './public/backlog_lib'

enable :sessions

# ログイン画面
get '/login' do
	haml :login
end

# ログイン処理
post '/do_login' do
	session[:username] = params[:username]
	session[:password] = params[:password]
	session[:space_id] = params[:space_id]
	redirect '/'
end

#アプリケーション画面
get '/' do
	haml :app
end

# プロジェクト一覧取得API
get '/get_projects' do
	client.execute("backlog.getProjects").to_json
end

# プロジェクト一覧取得API
get '/get_versions/:projectId' do
	client.execute("backlog.getVersions",params[:projectId].to_i).to_json
end

# チケット一覧取得API
get '/find_issue/:projectId' do
	client.execute("backlog.findIssue",{:projectId => params[:projectId].to_i}).to_json	
end

# Backlog接続クライアント取得
def client
	BacklogLib::Client.new(
		session[:space_id],session[:username],session[:password])
end

# scss
get '/css/base.css' do
  scss :base
end

get '/css/content.css' do
  scss :content
end
