# 基底コントローラークラス
app.controller('baseCtrl',($scope,$http,$routeParams) ->
	#コマンドリスト
	$scope.commands = []

	# プロジェクトID
	$scope.project_id = $routeParams.project_id

	# チケットの更新を行う
	$scope.update = () ->
		for command in $scope.commands
			command.execute($http)
		$scope.commands = [] #コマンドを空にする
)