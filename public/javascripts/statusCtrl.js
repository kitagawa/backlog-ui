app.controller('statusCtrl', function($scope, $http, $routeParams, $translate, $controller) {
  $controller('listBaseCtrl', {
    $scope: $scope
  });
  $scope.mode = 'status';
  $scope.initialize = function() {
    $scope.versions = [];
    $scope.selecting_version = {};
    $scope.loading = true;
    StatusColumn.find_all($http, function(data) {
      $scope.columns = data;
      return Version.find_all($http, $routeParams.project_id, function(versions_list) {
        var selecting_version;
        $scope.versions = versions_list;
        $translate('VERSION.ALL').then(function(translation) {
          return $scope.versions.unshift(new Version({
            name: translation
          }));
        });
        selecting_version = Version.select_current(versions_list);
        return $scope.switch_version(selecting_version);
      }, function(data, status, headers, config) {
        return $scope.show_error(status);
      });
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
    return $scope.sortable_options = {
      connectWith: '.column',
      stop: function(event, ui) {
        return $scope.set_update_status_command(ui);
      },
      receive: function(event, ui) {}
    };
  };
  $scope.set_update_status_command = function(ui) {
    var command, issue, status_column;
    issue = ui.item.sortable.moved;
    if (issue === void 0) {
      return;
    }
    status_column = $scope.find_column_include_issue(issue).first();
    command = issue.create_update_status_command(status_column);
    return Command.merge_commmand($scope.commands, command);
  };
  $scope.initialize();
  $scope.switch_version = function(version) {
    $scope.loading = true;
    $scope.toggle_selecting_version(version);
    return $scope.get_issues_by_version(version, function(data) {
      var column, _i, _len, _ref;
      _ref = $scope.columns;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        column = _ref[_i];
        column.clear();
        column.set_issues(data);
      }
      return $scope.loading = false;
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
  };
  $scope.toggle_selecting_version = function(version) {
    $scope.selecting_version.selected = false;
    $scope.selecting_version = version;
    return $scope.selecting_version.selected = true;
  };
  return $scope.get_issues_by_version = function(version, onSuccess, onError) {
    var option;
    option = {};
    if (version) {
      option['milestoneId'] = version.id;
    }
    return Issue.find_all($http, $routeParams.project_id, function(data) {
      return onSuccess(data);
    }, function(data, status, headers, config) {
      return onError(data, status, headers, config);
    }, option);
  };
});
