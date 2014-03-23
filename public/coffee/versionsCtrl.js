var versionsCtrl;

versionsCtrl = function($scope, $http, $routeParams) {
  $scope.initialize = function() {
    $scope.find_versions(function(data) {
      $scope.versions = Version.convert_versions(data);
      $scope.versions.unshift(new Version({
        name: "未設定"
      }));
      return $scope.find_issues(function(data) {
        var issues, version, _i, _j, _len, _len1, _ref, _ref1, _results;
        issues = Issue.convert_issues(data);
        _ref = $scope.versions;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          version = _ref[_i];
          version.set_issues(issues);
        }
        $scope.version_rows = [];
        _ref1 = $scope.versions;
        _results = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          version = _ref1[_j];
          _results.push($scope.version_rows.push(version.issues));
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
