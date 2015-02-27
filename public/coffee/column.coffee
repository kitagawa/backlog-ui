# チケット一覧をもつコンテナクラス
class Column
	#チケット一覧
	@issues: []

	# コンストラクタ
	# @param 属性
	constructor: (attributes) ->
		$.extend(this,attributes)
		this.issues = []
