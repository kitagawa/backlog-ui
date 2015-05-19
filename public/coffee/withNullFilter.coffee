# Null値がある場合のフィルター
# null値の表示を「未設定」に変換
app.filter('withNull', ()->
	(input)->
		if input == null or input == undefined
			"未設定"
		else
			input
)