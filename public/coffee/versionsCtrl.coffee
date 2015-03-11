app.controller('versionsCtrl',($scope,$http,$routeParams,$translate,$controller) ->
	# 基底コントローラーを継承
	$controller('baseCtrl',{$scope: $scope})

	# マイルストーン表示タイプ
	$scope.mode = 'version'

	# 初期設定
	$scope.initialize = () ->		
		Version.find_all($http,$routeParams.project_id,
			(data) ->
				$scope.columns = data
				# 未設定用のバージョンを一覧に追加
				$translate('VERSION.UNSET').then((translation)->
					$scope.columns.unshift(new Version(name: translation))
			  )

				# チケットの一覧を取得
				Issue.find_all($http, $routeParams.project_id,
					(data) ->
						# チケットにあったバージョンに配置
						for version in $scope.columns
						 	version.set_issues(data)
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