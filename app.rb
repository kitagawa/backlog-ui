require 'sinatra'
require 'haml'
require 'sass'
require 'json'
require './public/backlog_lib'

enable :sessions
set :session_secret, 'iu_go1kc@b'

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
		JSON.parse client.get("users/myself")
	end

	# ログイン状態をクリアする
	def clear_authed
		session[:api_key] = nil
		session[:space_id] = nil	
		session[:user_id] = nil
		session[:user_name] = nil
	end