require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require './public/backlog_lib'

# セッションを有効化
enable :sessions
set :session_secret, 'iu_go1kc@b'

# エラーハンドリングを有効化
set :show_exceptions, :after_handler
$stdout.sync = true

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

# OAUTHを行なう
post '/oauth' do
	session[:space_id] = params[:space_id]
	begin
		# OAUTH認証画面へリダイレクト
		url = "https://#{session[:space_id]}.backlog.jp/OAuth2AccessRequest.action"
		params = {
			'response_type' => "code", #固定値
			'client_id' => ENV['OAUTH_CLIENT_ID'],
		}
		redirect url + "?" +
		 params.collect{|k,v| "#{k}=#{v}"}.join("&")
	rescue Exception => e #入力されたログイン情報が正しくない
		@error = true
		haml :login
	end
end

# OAUTHからのリダイレクト受け
get '/return_oauth' do
	begin
		session[:code] = params[:code]
		# アクセストークンをセッションに設定する
		BacklogLib::OauthClient.set_access_token(session, session[:space_id],params['code'])

		# ログインユーザー情報を取得
		response = get_user_info
		session[:user_id] = response["id"]
		session[:user_name] = response["name"]		
		redirect '/'
	rescue Exception => e #入力されたログイン情報が正しくない
		@error = true
		haml :login
	end
end

# ログイン処理(APIキーを使用した場合)
post '/do_login' do
    session[:api_key] = params[:api_key]

  begin
		# ログインユーザー情報を取得
		response = get_user_info
		session[:user_id] = response["id"]
		session[:user_name] = response["name"]		
		redirect '/'
	rescue Exception => e #入力されたログイン情報が正しくない
		@error = true
		haml :login
	end
end

# ログインユーザーのアイコン画像取得
get '/my_icon' do
	client.get("users/#{session[:user_id]}/icon")
end

# ユーザーのアイコンが画像取得
get '/icon' do
	if params[:id] and params[:id] != ""
	client.get("users/#{params[:id]}/icon")
	else
	redirect '/images/person.png'
	end
end

#アプリケーション画面
get '/' do
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

# 状態の一覧取得API
get '/get_statuses' do
	client.get("statuses")
end

# チケット一覧取得API
get '/find_issue/:projectId' do
	_params = {"projectId[]" => params[:projectId].to_i}
	_params["milestoneId[]"] = params[:milestoneId].to_i if params[:milestoneId]
	_params["count"] = count = 100 #100件ごと取得

	# ページング初期設定
	page = 0
	complete = false
	response_body = []

	# 全件取得するまでまわす
	while not complete
		_params["offset"] = page * count
		response = client.get("issues",_params)

		# 結果が配列になるのでデータを結合
		body = JSON.parse(response)
		response_body += body

		# 取得内容が空だったらもう取りきったと判断
		if body.empty?
			complete = true
		else
			page += 1 #ページインクリメント
		end
	end

	# 並び替え
	# 期限日 > 優先度 > 状態
	response_body.sort_by!{|issue| [
		issue['dueDate'] ? issue['dueDate'] : "null", #nullのものは後ろに持っていく
		issue['priority']['id'],
		issue['status']['id']
		]}

	return response_body.to_json
end

# チケットの更新API
post '/update_issue/:issueKey' do
	data = JSON.parse(request.body.read)
	client.patch("issues/#{params[:issueKey]}",data)
end

# チケットのページへ遷移
get '/url/:issueKey' do
	redirect "https://#{session[:space_id]}.backlog.jp/view/#{params[:issueKey]}"
end

# エラーハンドリング
# 認証エラー
error BacklogLib::UnAuthenticationException do
	status 401
end

private
	# Backlog接続クライアント取得
	def client
		if session[:api_key]
			# APIキー認証した場合
			BacklogLib::Client.new(session)
		else
			# OAuth認証した場合
			BacklogLib::OauthClient.new(session)
		end

	end

	# ユーザー情報を取得する
	def get_user_info
		JSON.parse client.get("users/myself")
	end

	# ログイン状態をクリアする
	def clear_authed
		session[:api_key] = nil
		session[:space_id] = nil	
		session[:code] = nil
		session[:token_type] = nil
		session[:access_token] = nil
		session[:refresh_token] = nil
		session[:user_id] = nil
		session[:user_name] = nil
	end