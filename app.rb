require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require './public/backlog_lib'
require 'sinatra/r18n'

enable :sessions
set :session_secret, 'iu_go1kc@b'

R18n::I18n.default = 'ja'

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
	session[:api_key] = params[:api_key]
	session[:space_id] = params[:space_id]

	begin
		# ログインユーザー情報を取得
		response = get_user_info
		session[:user_id] = response["userId"]
		session[:user_name] = response["name"]		
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
	client.get("projects")
end

# バージョン一覧取得API
get '/get_versions/:projectId' do
	client.get("projects/#{params[:projectId].to_i}/versions")
end

# チケット一覧取得API
get '/find_issue/:projectId' do
	client.get("issues",{"projectId[]" => params[:projectId].to_i})
end

# チケットの更新API
post '/update_issue/:issueKey' do
	data = JSON.parse(request.body.read)
	client.patch("issues/#{params[:issueKey]}",data)
end

private
	# Backlog接続クライアント取得
	def client
		BacklogLib::Client.new(
			session[:api_key], session[:space_id])
	end

	# ログイン状態かをチェックする
	def is_authed?
		session[:api_key] and session[:space_id] and session[:user_name]
	end

	def get_user_info
		client.execute("users/myself")
	end

	# ログイン状態をクリアする
	def clear_authed
		session[:api_key] = nil
		session[:space_id] = nil	
		session[:user_id] = nil
		session[:user_name] = nil
	end