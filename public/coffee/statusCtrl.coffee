app.controller('statusCtrl',($scope,$http,$stateParams,$translate,$controller,ngDialog, statusService,versionService,issueService,commandService) ->
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
		statusService.find_all().then(
			(data) ->
				$scope.columns = data
				#マイルストーンの一覧を取得
				versionService.find_all($stateParams.project_id)
			
			,(data, status, headers, config)->
				$scope.show_error(status)
		).then(
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
						
			,(response)->
				$scope.show_error(response.status)
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
		commandService.store(command)

	# バージョンを切り替える
	$scope.switch_version = (version) ->
		# 未保存コマンドがあるか確認してから切り替え
		$scope.confirm_unsave(()->
			$scope.loading = true #ローディング表示
			# 選択中のバージョンを変更
			$scope.toggle_selecting_version(version)
			# チケットの読み込み
			$scope.load_tickets()
		)

	# チケットリストの読み込みを行なう
	$scope.load_tickets = () ->
		# ローディング表示
		$scope.loading = true;
		# バージョンにあったチケットを取得
		$scope.get_issues_by_version($scope.selecting_version).then(
			(data)->
				# チケットにあったステータスに配置
				for column in $scope.columns
					column.clear()
					column.set_issues(data)
				$scope.loading = false #ローディング非表示
			(response)->
				$scope.show_error(response.status)
			)


	# 選択中のバージョンを切り替える
	$scope.toggle_selecting_version = (version) ->
		$scope.selecting_version.selected = false
		$scope.selecting_version = version
		$scope.selecting_version.selected = true

	# バージョンにあったチケットの一覧を取得する
	# バージョン指定しない場合(すべて)の場合はversionをnullで指定
	$scope.get_issues_by_version = (version) ->
		option = {}
		if version
			option['milestoneId'] = version.id
		issueService.find_all($stateParams.project_id,option)
)


