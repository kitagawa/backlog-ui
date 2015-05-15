app.controller('projectsCtrl',($scope,$http,$controller) ->
		# 基底コントローラーを継承
	$controller('baseCtrl',{$scope: $scope})

	# 初期設定を行う
	$scope.initialize = () ->
		# プロジェクトの一覧を設定する
		$scope.find_projects().then(
			(data)-> 
				$scope.$parent.projects = data
			,(response)-> 
				$scope.show_error(response.status)
		)

	# プロジェクトの一覧を取得する
	$scope.find_projects = () ->
		$http(method: 'GET', url: '/get_projects').then(
			(response)->
				response.data
		)
)