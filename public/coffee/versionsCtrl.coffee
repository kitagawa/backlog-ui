versionsCtrl = ($scope,$http,$routeParams) ->
	# 初期設定
	$scope.initialize = () ->		
		$scope.find_versions(
			(data) ->
				$scope.versions = Version.convert_versions(data)
				# 未設定用のバージョンを一覧に追加
				$scope.versions.unshift(new Version(name: "未設定"))

				# # チケットの一覧を取得
				$scope.find_issues(
					(data) ->
						# チケットにあったバージョンに配置
						issues = Issue.convert_issues(data)
						for version in $scope.versions
						 	version.set_issues(issues)
					,(data, status, headers, config)->
						alert status
				)
			,(data, status, headers, config)->
				alert status
		)

		# UI-Sortableの変更された時の設定
		$scope.sortable_options =
			connectWith: '.row',
			update: (event,ui) ->
			receive: (evemt,ui) ->

	# マイルストーンの一覧を取得する
	$scope.find_versions = (on_success, on_error) ->
		$http(method: 'GET', url: '/get_versions/'+$routeParams.project_id)
		.success (data, status, headers, config)->
			on_success(data)
		.error (data, status, headers, config)->
			on_error(data, status, headers, config)

	# チケットの一覧を取得する
	$scope.find_issues = (on_success, on_error) ->
		$http(method: 'GET', url: '/find_issue/'+$routeParams.project_id)
		.success (data, status, headers, config) ->		
			on_success(data)
		.error (data, status, headers, config)->
			on_error(data, status, headers, config)

	# 初期設定を行う
	$scope.initialize()