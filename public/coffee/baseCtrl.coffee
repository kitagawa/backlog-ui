# 基底コントローラークラス
app.controller('baseCtrl',($scope,$http,$translate,$timeout) ->
	# ローディング表示
	$scope.loading = false

	#エラー表示
	$scope.error = false
	$scope.error_message = ""

	# エラーメッセージを表示
	$scope.show_error = (status) ->
		$scope.error = true
		$scope.loading = false
		$translate('MESSAGE.CONNECTION_ERROR').then((translation)->
			$scope.error_message = translation
	  )
		$timeout(()->
				$scope.error = false
			,2000
		);
)