function versionsCtrl($scope,$http){
	$http({method: 'GET', url: '/get_versions/1073815130'}).
			success(function(data, status, headers, config) {
				$scope.versions = data;
			}).
			error(function(data, status, headers, config) {
				alert(status);
			});
}