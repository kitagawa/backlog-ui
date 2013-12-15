

var app = angular.module('App', ['ngRoute','ui.sortable']);
app.config(function ($routeProvider) {
  $routeProvider
    .when('/',
	    {
	      templateUrl: "/html/projects.html",
	      controller: "projectsCtrl"
	    })
	  .when('/:project_id',
	    {
	      templateUrl: "/html/versions.html",
	      controller: "versionsCtrl"
	    }
	  )
});

