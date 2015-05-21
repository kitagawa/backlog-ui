# Null値がある場合のフィルター
# null値の表示を「未設定」に変換
app.filter('withNull', ($translate)->
	(input, interpolateParams, interpolation)->
		if input == null or input == undefined
			$translate.instant('NULL', interpolateParams, interpolation)
		else
			input
)