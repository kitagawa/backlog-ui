#コマンド
class Command

	# コンストラクタ
	# @param name コマンド名
	# @param コマンド値
	# @param 対象ID
	constructor: (name, data,key) ->
		@name = name
		@data = data
		@key = key

	# コマンドを実行
	execute: ($http) ->
		url = '/'+@name+'/'
		url += @key if @key
		$http.post(url,@data)

	# コマンドリストにコマンドをマージ
	# @param command_list 対象のコマンドリンスと
	# @param command 追加するコマンド
	@merge_commmand: (command_list, command) ->
		for _command in command_list
			if _command.name==command.name && _command.key == command.key
				Object.merge(_command.data, command.data)
				return
		command_list.push(command) #一致しなければ追加する
