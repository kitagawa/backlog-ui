app.controller('statusCtrl',($scope,$http,$stateParams,$translate,$controller,ngDialog) ->
	# 基底コントローラーを継承
	$controller('listBaseCtrl',{$scope: $scope})

	# マイルストーン表示タイプ
	$scope.mode = 'status'

	# 初期設定
	$scope.initialize = () ->		
		#マイルストーン一覧
		$scope.versions = []
		#選択中のマイルストーン
		$scope.selecting_version = {}
		# ローディング表示
		$scope.loading = true;

		# 状態一覧を取得
		StatusColumn.find_all($http,
			(data) ->
				$scope.columns = data

				#マイルストーンの一覧を取得
				Version.find_all($http,$stateParams.project_id,
					(versions_list) ->
						$scope.versions = versions_list
						# 「すべて」を一覧に追加
						$translate('VERSION.ALL').then((translation)->
							$scope.versions.unshift(new Version(name: translation))
					  )						
						# 期間中のマイルストーンを初期設定にする
						selecting_version = Version.select_current(versions_list)

						# 選択しているマイルストーンを切り替える
						$scope.switch_version(selecting_version)
						
					,(data, status, headers, config)->
						$scope.show_error(status)
				)
			,(data, status, headers, config)->
				$scope.show_error(status)
		)

		# UI-Sortableの変更された時の設定
		$scope.sortable_options =
			connectWith: '.column',
			stop: (event,ui) ->
				$scope.status_changed(ui)
			receive: (event,ui) ->

	# ステータスを変更時の処理
	$scope.status_changed = (ui) ->
		issue = ui.item.sortable.moved
		return if issue is undefined #移動したものがない場合
		status_column = $scope.find_column_include_issue(issue).first()
		# チケットのステータス変更
		issue.change_status(status_column)
		# 更新コマンドを作成
		$scope.set_update_status_command(issue,status_column)

	# チケットの更新コマンドを蓄積する
	$scope.set_update_status_command = (issue, status_column)->
		command = issue.create_update_status_command(status_column)
		Command.merge_commmand($scope.commands,command)

	# バージョンを切り替える
	$scope.switch_version = (version) ->
		$scope.loading = true #ローディング表示

		# 選択中のバージョンを変更
		$scope.toggle_selecting_version(version)
		# チケットの読み込み
		$scope.load_tickets()


	# チケットリストの読み込みを行なう
	$scope.load_tickets = () ->
		# ローディング表示
		$scope.loading = true;
		# バージョンにあったチケットを取得
		$scope.get_issues_by_version($scope.selecting_version
			, (data)->
				# チケットにあったステータスに配置
				for column in $scope.columns
					column.clear()
					column.set_issues(data)
				$scope.loading = false #ローディング非表示
			,(data, status, headers, config)->
				$scope.show_error(status)
		)

	# 選択中のバージョンを切り替える
	$scope.toggle_selecting_version = (version) ->
		$scope.selecting_version.selected = false
		$scope.selecting_version = version
		$scope.selecting_version.selected = true

	# バージョンにあったチケットの一覧を取得する
	# バージョン指定しない場合(すべて)の場合はversionをnullで指定
	$scope.get_issues_by_version = (version, onSuccess, onError) ->
		option = {}
		if version
			option['milestoneId'] = version.id
		Issue.find_all($http,$stateParams.project_id,
			(data)->
				onSuccess(data)
			,(data, status, headers, config)->
				onError(data, status, headers, config)
			,option
		)
)


