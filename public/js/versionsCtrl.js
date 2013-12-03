function versionsCtrl($scope,$http,$routeParams){
	$http({method: 'GET', url: '/get_versions/'+$routeParams.project_id}).
			success(function(data, status, headers, config) {
				$scope.versions = data;
			}).
			error(function(data, status, headers, config) {
				alert(status);
			});
}