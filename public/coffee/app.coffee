app = angular.module('App', ['ngRoute','ui.sortable','utils','pascalprecht.translate']);

# ルーティング設定
app.config ($routeProvider)->
  $routeProvider
  .when '/',
      templateUrl: "/html/projects.html",
      controller: "projectsCtrl"
  .when '/:project_id',
	  templateUrl: "/html/versions.html",
	  controller: "versionsCtrl"
  .when '/:project_id/status',
    templateUrl: "/html/status.html",
    controller: "statusCtrl"

#locale設定
app.config ['$translateProvider', ($translateProvider) ->
  $translateProvider.useStaticFilesLoader(
    prefix: 'locale/'
    suffix: '.json'
  )
  $translateProvider.preferredLanguage('ja');
  # $translateProvider.fallbackLanguage('en');
  $translateProvider.useMissingTranslationHandlerLog();
  # $translateProvider.useLocalStorage();
]