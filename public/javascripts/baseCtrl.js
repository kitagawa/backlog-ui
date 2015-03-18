app.controller('baseCtrl', function($scope, $http, $translate, $timeout) {
  $scope.loading = false;
  $scope.error = false;
  $scope.error_message = "";
  return $scope.show_error = function(status) {
    $scope.error = true;
    $scope.loading = false;
    $translate('MESSAGE.CONNECTION_ERROR').then(function(translation) {
      return $scope.error_message = translation;
    });
    return $timeout(function() {
      return $scope.error = false;
    }, 2000);
  };
});
