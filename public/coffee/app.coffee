app = angular.module('App', ['ngAnimate','ngRoute','ui.sortable','utils','pascalprecht.translate']);

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

# 優先順位表示フィルター
# 優先順位を矢印で表示する
app.filter('priority',()->
  (input)->
    if input.id == 3
      "t"
    else
      "s"
)