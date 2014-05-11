require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require './public/backlog_lib'

enable :sessions

# アプリケーション名
set :title, 'BacklogUI'

# ログイン画面
get '/login' do
	@title = settings.title
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
	@title = settings.title
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

# チケットの更新API
post '/update_issue/:issueKey' do
	data = JSON.parse request.body.read
	data[:key] = params[:issueKey]
	client.execute("backlog.updateIssue",data).to_json
end

# Backlog接続クライアント取得
def client
	BacklogLib::Client.new(
		session[:space_id],session[:username],session[:password])
end