app.controller('listBaseCtrl', function($scope, $http, $routeParams, $translate, $controller) {
  $scope.loading = false;
  $scope.commands = [];
  $scope.mode = '';
  $scope.project_id = $routeParams.project_id;
  $scope.update = function() {
    var command, commands_count, i, success_count, _i, _ref, _results;
    commands_count = $scope.commands.length;
    success_count = 0;
    _ref = $scope.commands;
    _results = [];
    for (i = _i = _ref.length - 1; _i >= 0; i = _i += -1) {
      command = _ref[i];
      $scope.loading = true;
      _results.push(command.execute($http, function(data) {
        $scope.commands.removeAt(i);
        if ($scope.commands.isEmpty()) {
          return $translate('MESSAGE.UPDATE_COMPLETE').then(function(translation) {
            return $scope.show_success(translation);
          });
        }
      }, function(data, status, headers, config) {
        return $scope.show_error(data);
      }));
    }
    return _results;
  };
  $scope.active_mode = function(mode) {
    return mode === $scope.mode;
  };
  $scope.find_column_include_issue = function(issue) {
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
  $scope.show_error = function(status) {
    $scope.$parent.show_error(status);
    return $scope.loading = false;
  };
  return $scope.show_success = function(status) {
    $scope.$parent.show_success(status);
    return $scope.loading = false;
  };
});
