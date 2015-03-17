app.controller('baseCtrl', function($scope, $http, $translate) {
  $scope.loading = false;
  $scope.error = false;
  $scope.error_message = "";
  return $scope.show_error = function(status) {
    $scope.error = true;
    $scope.loading = false;
    $translate('MESSAGE.CONNECTION_ERROR').then(function(translation) {
      return $scope.error_message = translation;
    });
    return setTimeout(function() {
      return $('#error_dialog').animate({
        opacity: '0'
      }, 3000, function() {
        $scope.error = false;
        return $scope.$apply();
      });
    }, 2000);
  };
});
