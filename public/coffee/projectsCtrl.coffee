app.controller('projectsCtrl',($scope,$http,$controller) ->
		# 基底コントローラーを継承
	$controller('baseCtrl',{$scope: $scope})

	# プロジェクトの一覧を取得する
	$scope.find_projects = () ->
		$http(method: 'GET', url: '/get_projects').then(
			(response)->
				$scope.$parent.projects = response.data
			,(response)-> 
				$scope.show_error(response.status)				
		)
)