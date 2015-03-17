app.controller('projectsCtrl',($scope,$http,$controller) ->
		# 基底コントローラーを継承
	$controller('baseCtrl',{$scope: $scope})

	# 初期設定を行う
	$scope.initialize = () ->
		# プロジェクトの一覧を設定する
		$scope.find_projects(
			(data)-> $scope.projects = data
			(data, status, headers, config)-> 
				$scope.show_error(status)
		)		

	# プロジェクトの一覧を取得する
	$scope.find_projects = (on_success, on_error) ->
		$http(method: 'GET', url: '/get_projects')
		.success (data, status, headers, config)->
			on_success(data)
		.error (data, status, headers, config)->
			on_error(data,status,headers,config)

	# 初期設定を行う
	$scope.initialize()
)