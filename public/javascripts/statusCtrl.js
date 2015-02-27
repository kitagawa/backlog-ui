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
        $scope.versions = versions_list;
        $translate('VERSION.ALL').then(function(translation) {
          return $scope.versions.unshift(new Version({
            name: translation
          }));
        });
        return $scope.selecting_version = Version.select_current(versions_list);
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
  return $scope.initialize();
});
