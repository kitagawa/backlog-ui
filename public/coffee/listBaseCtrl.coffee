# チケットリスト基底コントローラークラス
app.controller('listBaseCtrl',($scope,$http,$routeParams,$translate,$controller) ->

	# ローディング表示
	$scope.loading = false

	#コマンドリスト
	$scope.commands = []
	# 表示タイプ
	$scope.mode = ''

	# プロジェクトID
	$scope.project_id = $routeParams.project_id

	# チケットの更新を行う
	$scope.update = () ->
		commands_count = $scope.commands.length
		success_count = 0

		for command in $scope.commands
			$scope.loading = true
			command.execute($http,
				(data)->
					success_count += 1
					# if(success_count == commands_count)
					console.log(commands_count)
					console.log(success_count)

					$translate('MESSAGE.UPDATE_COMPLETE').then((translation)->
						$scope.show_success(translation)
				  )
				,(data, status, headers, config)->
					$scope.show_error(data)
			)
		$scope.commands = [] #コマンドを空にする

	# 現在の表示タイプとあっているか
	$scope.active_mode = (mode) ->
		mode == $scope.mode			

	# 指定のチケットを保持しているカラムを取得する
	$scope.find_column_include_issue = (issue) ->
		result = []
		for column in $scope.columns
			for _issue in column.issues
				if _issue == issue
					result.push(column)
		return result

	# エラーメッセージを表示する
	$scope.show_error = (status) ->
		$scope.$parent.show_error(status)
		$scope.loading = false

	# 完了メッセージを表示する
	$scope.show_success = (status) ->
		$scope.$parent.show_success(status)
		$scope.loading = false	
)