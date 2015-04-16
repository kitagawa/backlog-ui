module BacklogLib
	class Client
		require 'net/http'
		require 'uri'
		require 'json'

		attr_accessor :api_key, :space_id

		$stdout.sync = true

		# backlogAPIのURL
		URL = "backlog.jp/api/v2".freeze

		# Backlogへの接続設定を行います
		#* api_key: APIキー
		#* space_id: スペースID
		def initialize(api_key,space_id)
			self.api_key = api_key
			self.space_id = space_id
		end		

		# GETメソッドを実行します
		def get(method_name, params={})
			execute(method_name, 'get',params)
		end

		# PATCHメソッドを実行します
		def patch(method_name, params={})
			execute(method_name,'patch',params)
		end

		# BacklogへのAPIのURLを返す
		def raw(method_name,params={})
			return "https://#{self.space_id}.#{URL}/#{method_name}?apiKey=#{self.api_key}"
		end

		# APIを実行します
		#* method_name: API名
		#* method: HTTPメソッド(get,post,patch)
		#* params: APIに送るパラメーター
		def execute(method_name,method="get", params={})
			unless session_valid
				# セッションが切れている場合は401を返す
				raise UnAuthenticationException.new("session is empty")
			end
			# APIのurl作成
			url = "https://#{self.space_id}.#{URL}/#{method_name}?apiKey=#{self.api_key}"
			params_query = params.collect{|k,v| "#{k}=#{v}"}.join("&")

			# API実行
			case method 
			when "get"
				send(url + "&#{params_query}","get")
			when "patch"
				send(url, "patch", params_query)
			when "post"
				send(url, "post", params_query)
			end
		end

		# API実行
		def send(url, method, query=nil, header=nil)
			uri = URI.parse(url)
			response = Net::HTTP.start(uri.host,uri.port, use_ssl: true) do |http|
				case method 
				when "get"
					http.get(uri.request_uri,header)
				when "patch"
					http.patch(uri.request_uri, query,header)
				when "post"
					http.post(uri.request_uri, query,header)
				end
			end

			# レスポンス処理
			case response
			when Net::HTTPSuccess
				response.body
			when Net::HTTPFound
				send(response['location'],method,query,header) #リダイレクト
			when Net::HTTPSeeOther
				send(response['location'],method,query,header) #リダイレクト
			when Net::HTTPUnauthorized
				unauthorized(response,method,query,header) #認証エラー
			else
				#エラー
				puts url
				puts "#{response.code}: #{response.message}"
				puts response
				puts response.body
				raise Exception
			end			
		end

		# セッションが保持されているか
		def session_valid
			self.api_key and self.space_id
		end

		# 認証エラーの場合の処理
		def unauthorized(response,method,query,header)
			raise UnAuthenticationException.new(response.message)
		end
	end

	# OAuth認証時の接続クライアント
	class OauthClient < Client
		attr_accessor :code, :token_type, :access_token, :refresh_token
		require 'yaml'

		# Backlogへの接続設定を行います
		#* space_id: スペースID
		#* token_type: 認証形式(Bear)
		#* code: 認可コード
		#* access_token: アクセストークン
		#* refresh_token: リフレッシュトークン
		def initialize(space_id, code,token_type,access_token,refresh_token)
			self.space_id = space_id
			self.code = code
			self.token_type = token_type
			self.access_token = access_token
			self.refresh_token = refresh_token
		end

		# OAUTH認証で登録されているアプリケーション情報を取得する
		def self.client_info
			if ENV['OAUTH_CLIENT_ID'] && ENV['OAUTH_CLIENT_SECRET']
				# Heroku configから値を取得(本番用)
				{
					'client_id' => ENV['OAUTH_CLIENT_ID'],
					'client_secret' => ENV['OAUTH_CLIENT_SECRET']	
				}
			else
				# 設定ファイルから値を取得(開発用)
				setting_path = File.expand_path '../../spec/setting.yml', __FILE__
				setting = YAML.load_file(setting_path)
				{
					'client_id' => setting['client_id'],
					'client_secret' => setting['client_secret']	
				}
			end
		end

		# アクセストークンを取得する
		def self.get_access_token(space_id,code)
			client = self.new(space_id,code,nil,nil,nil)

			params = self.client_info.merge({
				'grant_type' => 'authorization_code', #固定値
				'code' => code
			})
			url = "https://#{space_id}.backlog.jp/api/v2/oauth2/token?" +
				params.collect{|k,v| "#{k}=#{v}"}.join("&")
			response = client.send(url, "post")
			return JSON.parse(response)
		end

		# アクセストークンをリフレッシュする
		def refresh_access_token
			params = self.client_info.merge({
				'grant_type' => 'refresh_token', #固定値
				'refresh_token' => self.refresh_token
			})
			url = "https://#{space_id}.backlog.jp/api/v2/oauth2/token?" +
				params.collect{|k,v| "#{k}=#{v}"}.join("&")
			response = client.send(url, "post")
			return JSON.parse(response)			
		end

		# APIを実行します
		#* method_name: API名
		#* method: HTTPメソッド(get,post,patch)
		#* params: APIに送るパラメーター
		def execute(method_name,method="get", params={})
			unless session_valid
				# セッションが切れている場合は401を返す
				raise UnAuthenticationException
			end

			# APIのurl作成
			url = "https://#{self.space_id}.#{URL}/#{method_name}"
			params_query = params.collect{|k,v| "#{k}=#{v}"}.join("&")
			# トークンをヘッダーに設定
			header = {
				"Authorization" => "#{self.token_type} #{self.access_token}"
			}
			# API実行
			case method 
			when "get"
				send(url + "?#{params_query}","get",nil,header)
			when "patch"
				send(url, "patch", params_query,header)
			when "post"
				send(url, "post", params_query,header)
			end
		end

		# 認証エラーの場合の処理
		def unauthorized(response,method,query,header)
			# アクセストークンの期限切れ
			if response.header["www-authenticate"] == 
				'Bearer error="invalid_token", error_description="The access token expired"'
				# refresh_token
			else
				raise UnAuthenticationException.new(response.message)
			end
		end

		# セッションが保持されているか
		def session_valid
			self.space_id and self.access_token and self.refresh_token
		end

	end

	# 権限エラー時の例外
	class UnAuthenticationException < Exception
    def initialize(message = "Unauthorized")
      super(message)
    end
  end
end