app.controller('baseCtrl', function($scope, $http, $routeParams) {
  $scope.commands = [];
  $scope.project_id = $routeParams.project_id;
  return $scope.update = function() {
    var command, _i, _len, _ref;
    _ref = $scope.commands;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      command = _ref[_i];
      command.execute($http);
    }
    return $scope.commands = [];
  };
});
