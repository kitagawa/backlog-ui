app.controller('versionsCtrl',($scope,$http,$routeParams,$controller) ->
	# 基底コントローラーを継承
	$controller('baseCtrl',{$scope: $scope})

	# 初期設定
	$scope.initialize = () ->		
		Version.find_all($http,$routeParams.project_id,
			(data) ->
				$scope.columns = data
				# 未設定用のバージョンを一覧に追加
				$scope.columns.unshift(new Version(name: "未設定"))

				# # チケットの一覧を取得
				$scope.find_issues(
					(data) ->
						# チケットにあったバージョンに配置
						issues = Issue.convert_issues(data)
						for version in $scope.columns
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
			stop: (event,ui) ->
				$scope.set_update_issue_milestone(ui)
			receive: (event,ui) ->

	# チケットの一覧を取得する
	$scope.find_issues = (on_success, on_error) ->
		$http(method: 'GET', url: '/find_issue/'+$routeParams.project_id)
		.success (data, status, headers, config) ->		
			on_success(data)
		.error (data, status, headers, config)->
			on_error(data, status, headers, config)

	# チケットの更新コマンドを蓄積する
	$scope.set_update_issue_milestone = (ui)->
		issue = ui.item.sortable.moved
		return if issue is undefined #移動したものがない場合
		versions = $scope.find_version_included_issue(issue)
		command = issue.create_update_milestone_command(versions)
		Command.merge_commmand($scope.commands,command)

	# 指定のチケットを保持しているマイルストーンを取得する
	$scope.find_version_included_issue = (issue) ->
		result = []
		for version in $scope.columns
			for _issue in version.issues
				if _issue == issue
					result.push(version)
		return result

	# 初期設定を行う
	$scope.initialize()
)