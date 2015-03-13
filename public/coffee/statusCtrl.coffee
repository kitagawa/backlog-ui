app.controller('statusCtrl',($scope,$http,$routeParams,$translate,$controller) ->
	# 基底コントローラーを継承
	$controller('baseCtrl',{$scope: $scope})

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
				Version.find_all($http,$routeParams.project_id,
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
						alert status
				)
			,(data, status, headers, config)->
				alert status
		)

		# UI-Sortableの変更された時の設定
		$scope.sortable_options =
			connectWith: '.column',
			stop: (event,ui) ->
				$scope.set_update_status_command(ui)
			receive: (event,ui) ->

	# チケットの更新コマンドを蓄積する
	$scope.set_update_status_command = (ui)->
		issue = ui.item.sortable.moved
		return if issue is undefined #移動したものがない場合
		status_column = $scope.find_column_include_issue(issue).first()
		command = issue.create_update_status_command(status_column)
		Command.merge_commmand($scope.commands,command)

	# 初期設定を行う
	$scope.initialize()

	# バージョンを切り替える
	$scope.switch_version = (version) ->
		$scope.loading = true #ローディング表示

		# 選択中のバージョンを変更
		$scope.toggle_selecting_version(version)
		# バージョンにあったチケットを取得
		$scope.get_issues_by_version(version
			, (data)->
				# チケットにあったステータスに配置
				for column in $scope.columns
					column.clear()
					column.set_issues(data)
				$scope.loading = false #ローディング非表示
			,(data, status, headers, config)->
				alert status
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
		Issue.find_all($http,$routeParams.project_id,
			(data)->
				onSuccess(data)
			,(data, status, headers, config)->
				onError(data, status, headers, config)
			,option
		)
)


