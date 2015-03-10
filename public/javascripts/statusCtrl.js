app.controller('statusCtrl', function($scope, $http, $routeParams, $translate, $controller) {
  $controller('baseCtrl', {
    $scope: $scope
  });
  $scope.initialize = function() {
    $scope.versions = [];
    $scope.selecting_version = {};
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
        return alert(status);
      });
    }, function(data, status, headers, config) {
      return alert(status);
    });
    return $scope.sortable_options = {
      connectWith: '.row',
      stop: function(event, ui) {},
      receive: function(event, ui) {}
    };
  };
  $scope.initialize();
  $scope.switch_version = function(version) {
    $scope.toggle_selecting_version(version);
    return $scope.get_issues_by_version(version, function(data) {
      var column, _i, _len, _ref, _results;
      _ref = $scope.columns;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        column = _ref[_i];
        column.clear();
        _results.push(column.set_issues(data));
      }
      return _results;
    }, function(data, status, headers, config) {
      return alert(status);
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
