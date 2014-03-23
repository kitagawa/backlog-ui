var versionsCtrl;

versionsCtrl = function($scope, $http, $routeParams) {
  $scope.initialize = function() {
    $scope.find_versions(function(data) {
      $scope.versions = Version.convert_versions(data);
      $scope.versions.unshift(new Version({
        name: "未設定"
      }));
      return $scope.find_issues(function(data) {
        var issues, version, _i, _len, _ref, _results;
        issues = Issue.convert_issues(data);
        _ref = $scope.versions;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          version = _ref[_i];
          _results.push(version.set_issues(issues));
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
      update: function(event, ui) {},
      receive: function(evemt, ui) {}
    };
  };
  $scope.find_versions = function(on_success, on_error) {
    return $http({
      method: 'GET',
      url: '/get_versions/' + $routeParams.project_id
    }).success(function(data, status, headers, config) {
      return on_success(data);
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };
  $scope.find_issues = function(on_success, on_error) {
    return $http({
      method: 'GET',
      url: '/find_issue/' + $routeParams.project_id
    }).success(function(data, status, headers, config) {
      return on_success(data);
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };
  return $scope.initialize();
};
