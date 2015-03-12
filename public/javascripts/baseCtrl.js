app.controller('baseCtrl', function($scope, $http, $routeParams) {
  $scope.commands = [];
  $scope.mode = '';
  $scope.project_id = $routeParams.project_id;
  $scope.update = function() {
    var command, _i, _len, _ref;
    _ref = $scope.commands;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      command = _ref[_i];
      command.execute($http);
    }
    return $scope.commands = [];
  };
  $scope.active_mode = function(mode) {
    return mode === $scope.mode;
  };
  return $scope.find_column_include_issue = function(issue) {
    var column, result, _i, _issue, _j, _len, _len1, _ref, _ref1;
    result = [];
    _ref = $scope.columns;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      column = _ref[_i];
      _ref1 = column.issues;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        _issue = _ref1[_j];
        if (_issue === issue) {
          result.push(column);
        }
      }
    }
    return result;
  };
});
