require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require './public/backlog_lib'
require 'sinatra/r18n'

enable :sessions

# アプリケーション名
set :title, 'BacklogUI'

# ログイン画面
get '/login' do
	@title = settings.title
	haml :login
end

get '/logout' do
	clear_authed
	redirect '/login'
end

# ログイン処理
post '/do_login' do
	session[:user_id] = params[:user_id]
	session[:password] = params[:password]
	session[:space_id] = params[:space_id]

	begin
		# ログインユーザー情報を取得
		response = get_user_info
		session[:username] = response["name"]		
		redirect '/'
	rescue Exception => e #入力されたログイン情報が正しくない
		@error = true
		haml :login
	end
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
		session[:space_id],session[:user_id],session[:password])
end

# ログイン状態かをチェックする
def is_authed?
	session[:user_id] and session[:password] and session[:space_id]
end

def get_user_info
	client.execute("backlog.getUser",session[:user_id])
end

# ログイン状態をクリアする
def clear_authed
	session[:user_id] = nil
	session[:password] = nil
	session[:space_id] = nil
end