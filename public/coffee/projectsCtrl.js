var projectsCtrl;

projectsCtrl = function($scope, $http) {
  return $http({
    method: 'GET',
    url: '/get_projects'
  }).success(function(data, status, headers, config) {
    return $scope.projects = data;
  }).error(function(data, status, headers, config) {
    return alert(status);
  });
};
