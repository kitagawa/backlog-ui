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