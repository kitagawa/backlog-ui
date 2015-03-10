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
        var option, selecting_version;
        $scope.versions = versions_list;
        $translate('VERSION.ALL').then(function(translation) {
          return $scope.versions.unshift(new Version({
            name: translation
          }));
        });
        selecting_version = Version.select_current(versions_list);
        $scope.switch_selecting_version(selecting_version);
        option = {};
        if (selecting_version) {
          option['milestoneId'] = selecting_version.id;
        }
        return Issue.find_all($http, $routeParams.project_id, function(data) {
          var column, _i, _len, _ref, _results;
          _ref = $scope.columns;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            column = _ref[_i];
            _results.push(column.set_issues(data));
          }
          return _results;
        }, function(data, status, headers, config) {
          return alert(status);
        }, option);
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
  return $scope.switch_selecting_version = function(version) {
    $scope.selecting_version.selected = false;
    $scope.selecting_version = version;
    return $scope.selecting_version.selected = true;
  };
});
