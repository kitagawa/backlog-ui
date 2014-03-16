var filter_milestone, versionsCtrl;

versionsCtrl = function($scope, $http, $routeParams) {
  $http({
    method: 'GET',
    url: '/get_versions/' + $routeParams.project_id
  }).success(function(data, status, headers, config) {
    var versions;
    versions = Version.convert_versions(data);
    versions.unshift(new Version({
      name: "未設定"
    }));
    $scope.versions = versions;
    return $http({
      method: 'GET',
      url: '/find_issue/' + $routeParams.project_id
    }).success(function(data, status, headers, config) {
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
    }).error(function(data, status, headers, config) {
      return alert(status);
    });
  }).error(function(data, status, headers, config) {
    return alert(status);
  });
  return $scope.sortable_options = {
    connectWith: '.row',
    update: function(event, ui) {},
    receive: function(evemt, ui) {}
  };
};

app.filter('milestoneFilter', function() {
  return function(items, version_id) {
    var filtered_issues;
    filtered_issues = filter_milestone(items, version_id);
    return filtered_issues;
  };
});

filter_milestone = function(issues, version_id) {
  var filtered_issues, issue, _i, _len;
  filtered_issues = [];
  issue;
  for (_i = 0, _len = issues.length; _i < _len; _i++) {
    issue = issues[_i];
    if (issue.is_include_milestone(version_id)) {
      filtered_issues.push(issue);
    }
  }
  return filtered_issues;
};
