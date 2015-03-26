app = angular.module('App', ['ngAnimate','ui.router','ui.sortable','utils','pascalprecht.translate']);

# ルーティング設定
app.config ($stateProvider, $urlRouterProvider)->
  $urlRouterProvider.otherwise '/'
  $stateProvider
  .state(
      'projects',
      url: '/',
      templateUrl: "/html/projects.html",
      controller: "projectsCtrl"
    )
  .state(
      'versions',
      url: '/:project_id',
      views:
        '': 
          templateUrl: "/html/body.html"
          controller: "versionsCtrl"
        'menu@versions':
          templateUrl: "/html/shared/issue.html"
        'list@versions':
          templateUrl: "/html/versions.html"
    ) 
  .state(
      'status',
      url: '/:project_id/status'
      views:
        '':
          templateUrl: "/html/body.html"
          controller: "statusCtrl"
        'menu@status':
          templateUrl: "/html/shared/issue.html"
        'list@status':
          templateUrl: "/html/status.html"
    ) 

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