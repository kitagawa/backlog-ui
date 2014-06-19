var app;

app = angular.module('App', ['ngRoute', 'ui.sortable', 'utils']);

app.config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: "/html/projects.html",
    controller: "projectsCtrl"
  }).when('/:project_id', {
    templateUrl: "/html/versions.html",
    controller: "versionsCtrl"
  });
});
