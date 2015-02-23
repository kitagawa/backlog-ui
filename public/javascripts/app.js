var app;

app = angular.module('App', ['ngRoute', 'ui.sortable', 'utils', 'pascalprecht.translate']);

app.config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: "/html/projects.html",
    controller: "projectsCtrl"
  }).when('/:project_id', {
    templateUrl: "/html/versions.html",
    controller: "versionsCtrl"
  });
});

app.config([
  '$translateProvider', function($translateProvider) {
    $translateProvider.useStaticFilesLoader({
      prefix: 'locale/',
      suffix: '.json'
    });
    $translateProvider.preferredLanguage('ja');
    $translateProvider.fallbackLanguage('en');
    return $translateProvider.useMissingTranslationHandlerLog();
  }
]);
