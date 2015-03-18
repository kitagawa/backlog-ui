# 基底コントローラークラス
app.controller('baseCtrl',($scope,$http,$translate,$timeout) ->
	# ローディング表示
	$scope.loading = false

	# 完了表示
	$scope.success = false
	$scope.success_message = ""

	#エラー表示
	$scope.error = false
	$scope.error_message = ""

	# 完了メッセージを表示
	$scope.show_success = (message) ->
		$scope.success = true
		$scope.loading = false
		$scope.success_message = message
		$timeout(()->
				$scope.success = false
			,2000
		);

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