var app;

app = angular.module('App', ['ngRoute', 'ui.sortable', 'utils', 'pascalprecht.translate']);

app.config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: "/html/projects.html",
    controller: "projectsCtrl"
  }).when('/:project_id', {
    templateUrl: "/html/versions.html",
    controller: "versionsCtrl"
  }).when('/:project_id/status', {
    templateUrl: "/html/status.html",
    controller: "statusCtrl"
  });
});

app.config([
  '$translateProvider', function($translateProvider) {
    $translateProvider.useStaticFilesLoader({
      prefix: 'locale/',
      suffix: '.json'
    });
    $translateProvider.preferredLanguage('ja');
    return $translateProvider.useMissingTranslationHandlerLog();
  }
]);
