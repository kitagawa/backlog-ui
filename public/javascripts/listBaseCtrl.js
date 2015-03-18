app.controller('listBaseCtrl', function($scope, $http, $routeParams, $translate, $controller) {
  $controller('baseCtrl', {
    $scope: $scope
  });
  $scope.commands = [];
  $scope.mode = '';
  $scope.project_id = $routeParams.project_id;
  $scope.update = function() {
    var command, commands_count, success_count, _i, _len, _ref;
    commands_count = $scope.commands.length;
    success_count = 0;
    _ref = $scope.commands;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      command = _ref[_i];
      $scope.loading = true;
      command.execute($http, function(data) {
        success_count += 1;
        console.log(commands_count);
        console.log(success_count);
        return $translate('MESSAGE.UPDATE_COMPLETE').then(function(translation) {
          return $scope.show_success(translation);
        });
      }, function(data, status, headers, config) {
        return $scope.show_error(data);
      });
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
