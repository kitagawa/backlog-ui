app.controller('versionsCtrl', function($scope, $http, $routeParams, $translate, $controller) {
  $controller('baseCtrl', {
    $scope: $scope
  });
  $scope.mode = 'version';
  $scope.initialize = function() {
    $scope.loading = true;
    Version.find_all($http, $routeParams.project_id, function(data) {
      $scope.columns = data;
      $translate('VERSION.UNSET').then(function(translation) {
        return $scope.columns.unshift(new Version({
          name: translation
        }));
      });
      return Issue.find_all($http, $routeParams.project_id, function(data) {
        var version, _i, _len, _ref;
        _ref = $scope.columns;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          version = _ref[_i];
          version.set_issues(data);
        }
        return $scope.loading = false;
      }, function(data, status, headers, config) {
        return alert(status);
      });
    }, function(data, status, headers, config) {
      return alert(status);
    });
    return $scope.sortable_options = {
      connectWith: '.column',
      stop: function(event, ui) {
        return $scope.set_update_issue_milestone(ui);
      },
      receive: function(event, ui) {}
    };
  };
  $scope.set_update_issue_milestone = function(ui) {
    var command, issue, versions;
    issue = ui.item.sortable.moved;
    if (issue === void 0) {
      return;
    }
    versions = $scope.find_column_include_issue(issue);
    command = issue.create_update_milestone_command(versions);
    return Command.merge_commmand($scope.commands, command);
  };
  return $scope.initialize();
});
