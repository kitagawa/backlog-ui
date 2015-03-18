app.controller('baseCtrl', function($scope, $http, $translate, $timeout) {
  $scope.success = false;
  $scope.success_message = "";
  $scope.error = false;
  $scope.error_message = "";
  $scope.show_success = function(message) {
    $scope.success = true;
    $scope.success_message = message;
    return $timeout(function() {
      return $scope.success = false;
    }, 2000);
  };
  return $scope.show_error = function(status) {
    $scope.error = true;
    $translate('MESSAGE.CONNECTION_ERROR').then(function(translation) {
      return $scope.error_message = translation;
    });
    return $timeout(function() {
      return $scope.error = false;
    }, 2000);
  };
});
