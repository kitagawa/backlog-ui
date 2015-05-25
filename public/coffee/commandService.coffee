app.factory('commandService', ($http)->
	#コマンドリスト
	commands = []

	# コマンドを蓄積する
	store: (command) ->
		# 同一のキーのコマンドはマージする
		for _command in commands
			if _command.name==command.name && _command.key == command.key
				Object.merge(_command.data, command.data)
				return
		commands.push(command) #一致しなければ追加する

	# 蓄積されているコマンドを実行する
	execute: (on_success, on_error)->
		for command,i in commands by -1
			url = '/'+command.name+'/'
			url += command.key if command.key
			
			$http.post(url,command.data)
			.success (data, status, headers, config) ->
				commands.removeAt(i) #実行したものは削除
				# すべてのコマンドが実行されたら完了
				if commands.isEmpty()
					on_success()
			.error (data, status, headers, config)->
				# エラーが発生したら途中で終了
				on_error(data, status, headers, config)
				return

	# 蓄積されているコマンドをクリアする
	clear: ()->
		commands = []

	# 蓄積されているコマンドを取得する
	list: ()->
		commands
)
