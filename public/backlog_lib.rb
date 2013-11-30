module BacklogLib
	class Client
		require 'xmlrpc/client'
		# backlogAPIのURL
		URL = "backlog.jp/XML-RPC".freeze

		# Backlogへの接続設定を行います
		#* space_id: スペースID
		#* user: ユーザ名
		#* password: パスワード
		def initialize(space_id,username,password)
			@client = XMLRPC::Client.new2("https://#{username}:#{password}@#{space_id}.#{URL}")
			@client.user = username
			@client.password = password
		end		

		# APIを実行します
		#* method_name: API名
		#* params: APIに送るパラメーター
		def execute(method_name,params=nil)
			if params
				@client.call(method_name,params)
			else
				@client.call(method_name)
			end
		end
	end
end