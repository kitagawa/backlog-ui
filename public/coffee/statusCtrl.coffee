app.controller('statusCtrl',($scope,$http,$routeParams) ->

	# 初期設定
	$scope.initialize = () ->		
		#マイルストーン一覧
		$scope.versions = []
		#選択中のマイルストーン
		$scope.selecting_version = {}

		# 状態一覧を取得
		StatusColumn.find_all($http,
			(data) ->
				$scope.columns = data

				#マイルストーンの一覧を取得
				Version.find_all($http,$routeParams.project_id,
					(versions_list) ->
						$scope.versions = versions_list
						# 期間中のマイルストーンを初期設定にする
						$scope.selecting_version = Version.select_count(versions_list)

					,(data, status, headers, config)->
						alert status
				)
		# 		# # チケットの一覧を取得
		# 		$scope.find_issues(
		# 			(data) ->
		# 				# チケットにあったバージョンに配置
		# 				issues = Issue.convert_issues(data)
		# 				for version in $scope.columns
		# 				 	version.set_issues(issues)
		# 			,(data, status, headers, config)->
		# 				alert status
		# 		)
			,(data, status, headers, config)->
				alert status
		)

		# UI-Sortableの変更された時の設定
		$scope.sortable_options =
			connectWith: '.row',
			stop: (event,ui) ->
				# $scope.set_update_issue_milestone(ui)
			receive: (event,ui) ->

	# # チケットの一覧を取得する
	# $scope.find_issues = (on_success, on_error) ->
	# 	$http(method: 'GET', url: '/find_issue/'+$routeParams.project_id)
	# 	.success (data, status, headers, config) ->		
	# 		on_success(data)
	# 	.error (data, status, headers, config)->
	# 		on_error(data, status, headers, config)

	# # チケットの更新コマンドを蓄積する
	# $scope.set_update_issue_milestone = (ui)->
	# 	issue = ui.item.sortable.moved
	# 	return if issue is undefined #移動したものがない場合
	# 	versions = $scope.find_version_included_issue(issue)
	# 	command = issue.create_update_milestone_command(versions)
	# 	Command.merge_commmand($scope.commands,command)

	# # 指定のチケットを保持しているマイルストーンを取得する
	# $scope.find_version_included_issue = (issue) ->
	# 	result = []
	# 	for version in $scope.columns
	# 		for _issue in version.issues
	# 			if _issue == issue
	# 				result.push(version)
	# 	return result

	# 初期設定を行う
	$scope.initialize()
)