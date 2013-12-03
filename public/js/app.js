var app = angular.module('App', ['ngRoute']);
app.config(function ($routeProvider) {
  $routeProvider
    .when('/',
	    {
	      templateUrl: "/partials/projects.html",
	      controller: "projectsCtrl"
	    })
	  .when('/:project_id',
	    {
	      templateUrl: "/partials/versions.html",
	      controller: "versionsCtrl"
	    }
	  )
});