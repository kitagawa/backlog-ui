app.controller('versionsCtrl',($scope,$http,$stateParams,$translate,$controller) ->
	# 基底コントローラーを継承
	$controller('listBaseCtrl',{$scope: $scope})

	# マイルストーン表示タイプ
	$scope.mode = 'version'

	# 初期設定
	$scope.initialize = () ->		
		# ローディング表示
		$scope.loading = true;
		Version.find_all($http,$stateParams.project_id,
			(data) ->
				$scope.columns = data
				# 未設定用のバージョンを一覧に追加
				$translate('VERSION.UNSET').then((translation)->
					$scope.columns.unshift(new Version(name: translation))
			  )
			  # チケット読み込み
				$scope.load_tickets()
			,(data, status, headers, config)->
				$scope.show_error(status)
		)

		# UI-Sortableの変更された時の設定
		$scope.sortable_options =
			connectWith: '.column',
			stop: (event,ui) ->
				$scope.set_update_issue_milestone(ui)
			receive: (event,ui) ->

	# チケット一覧の読み込み
	$scope.load_tickets= () ->
		# ローディング表示
		$scope.loading = true;

		Issue.find_all($http, $stateParams.project_id,
			(data) ->
				# チケットにあったバージョンに配置
				for version in $scope.columns
					version.clear()
					version.set_issues(data)
				$scope.loading = false #ローディング非表示
			,(data, status, headers, config)->
				$scope.show_error(status)
		)

	# チケット一覧の再読み込み
	$scope.refresh = () ->
		if $scope.unsaved()
		else
			$scope.load_tickets()

	# チケットの更新コマンドを蓄積する
	$scope.set_update_issue_milestone = (ui)->
		issue = ui.item.sortable.moved
		return if issue is undefined #移動したものがない場合
		versions = $scope.find_column_include_issue(issue)
		command = issue.create_update_milestone_command(versions)
		Command.merge_commmand($scope.commands,command)
)