# 基底コントローラークラス
app.controller('baseCtrl',($scope,$http,$routeParams) ->
	#コマンドリスト
	$scope.commands = []
	# 表示タイプ
	$scope.mode = ''

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
)