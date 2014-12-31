module BacklogLib
	class Client
		require 'net/http'
		require 'uri'
		require 'json'

		attr_accessor :api_key, :space_id

		# backlogAPIのURL
		URL = "backlog.jp/api/v2".freeze

		# Backlogへの接続設定を行います
		#* api_key: APIキー
		#* space_id: スペースID
		def initialize(api_key,space_id)
			self.api_key = api_key
			self.space_id = space_id
		end		

		# APIを実行します
		#* method_name: API名
		#* params: APIに送るパラメーター
		def execute(method_name,params=nil)
			# APIのurl作成
			params ||={}
			params[:apiKey] = self.api_key
			params_url = params.collect{|k,v| "#{k}=#{v}"}.join("&")
			url = "https://#{self.space_id}.#{URL}/#{method_name}?#{params_url}"
			uri = URI.parse(url)

			# API実行
			response = Net::HTTP.start(uri.host,uri.port, use_ssl: true) do |http|
				http.get(uri.request_uri)
			end

			# レスポンス処理
			case response
			when Net::HTTPSuccess
				JSON.parse(response.body)
			else
				puts "#{response.code}: #{response.message}"
				raise Exception
			end
		end
	end
end