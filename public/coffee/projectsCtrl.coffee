projectsCtrl = ($scope,$http) ->
	$http(method: 'GET', url: '/get_projects')
		.success (data, status, headers, config)->
			$scope.projects = data
		.error (data, status, headers, config)->
			alert status