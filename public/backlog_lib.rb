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
			# APIのurl作成
			url = "https://#{self.space_id}.#{URL}/#{method_name}?apiKey=#{self.api_key}"
			params_query = params.collect{|k,v| "#{k}=#{v}"}.join("&")

			# API実行
			case method 
			when "get"
				send(url + "&#{params_query}","get")
			when "patch"
				send(url, "patch", params_query)
			end
		end

		# API実行
		def send(url, method, query=nil)
			uri = URI.parse(url)
			response = Net::HTTP.start(uri.host,uri.port, use_ssl: true) do |http|
				case method 
				when "get"
					http.get(uri.request_uri)
				when "patch"
					http.patch(uri.request_uri, query)
				end
			end

			# レスポンス処理
			case response
			when Net::HTTPSuccess
				response.body
			when Net::HTTPFound
				send(response['location'],method,query) #リダイレクト
			when Net::HTTPSeeOther
				send(response['location'],method,query) #リダイレクト
			else
				#エラー
				puts url
				puts "#{response.code}: #{response.message}"
				puts response
				puts response.body
				raise Exception
			end			
		end
	end
end