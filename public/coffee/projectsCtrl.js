var projectsCtrl;

projectsCtrl = function($scope, $http) {
  $scope.initialize = function() {
    return $scope.find_projects(function(data) {
      return $scope.projects = data;
    }, function(data, status, headers, config) {
      return alert(status);
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
};
