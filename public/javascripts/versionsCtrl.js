app.controller('versionsCtrl', function($scope, $http, $routeParams, $translate, $controller) {
  $controller('baseCtrl', {
    $scope: $scope
  });
  $scope.initialize = function() {
    Version.find_all($http, $routeParams.project_id, function(data) {
      $scope.columns = data;
      $translate('VERSION.UNSET').then(function(translation) {
        return $scope.columns.unshift(new Version({
          name: translation
        }));
      });
      return Issue.find_all($http, $routeParams.project_id, function(data) {
        var version, _i, _len, _ref, _results;
        _ref = $scope.columns;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          version = _ref[_i];
          _results.push(version.set_issues(data));
        }
        return _results;
      }, function(data, status, headers, config) {
        return alert(status);
      });
    }, function(data, status, headers, config) {
      return alert(status);
    });
    return $scope.sortable_options = {
      connectWith: '.row',
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
    versions = $scope.find_version_included_issue(issue);
    command = issue.create_update_milestone_command(versions);
    return Command.merge_commmand($scope.commands, command);
  };
  $scope.find_version_included_issue = function(issue) {
    var result, version, _i, _issue, _j, _len, _len1, _ref, _ref1;
    result = [];
    _ref = $scope.columns;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      version = _ref[_i];
      _ref1 = version.issues;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        _issue = _ref1[_j];
        if (_issue === issue) {
          result.push(version);
        }
      }
    }
    return result;
  };
  return $scope.initialize();
});
