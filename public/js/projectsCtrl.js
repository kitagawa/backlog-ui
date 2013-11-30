function projectsCtrl($scope,$http){
	$http({method: 'GET', url: '/get_projects'}).
			success(function(data, status, headers, config) {
				$scope.projects = data;
			}).
			error(function(data, status, headers, config) {
				alert(status);
			});
}