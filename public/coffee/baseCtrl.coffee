# 基底コントローラークラス
app.controller('baseCtrl',($scope,$http,$routeParams) ->
	#コマンドリスト
	$scope.commands = []
	# 表示タイプ
	$scope.mode = ''

	# ローディング表示
	$scope.loading = false

	# プロジェクトID
	$scope.project_id = $routeParams.project_id

	# チケットの更新を行う
	$scope.update = () ->
		for command in $scope.commands
			command.execute($http)
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

)