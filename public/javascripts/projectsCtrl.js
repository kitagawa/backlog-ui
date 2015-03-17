app.controller('projectsCtrl', function($scope, $http, $controller) {
  $controller('baseCtrl', {
    $scope: $scope
  });
  $scope.initialize = function() {
    return $scope.find_projects(function(data) {
      return $scope.projects = data;
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
  };
  $scope.find_projects = function(on_success, on_error) {
    return $http({
      method: 'GET',
      url: '/get_projects'
    }).success(function(data, status, headers, config) {
      return on_success(data);
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };
  return $scope.initialize();
});
