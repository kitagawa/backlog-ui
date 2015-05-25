# チケットリスト基底コントローラークラス
app.controller('listBaseCtrl',($scope,$http,$state,$stateParams,$translate,$controller,ngDialog, commandService) ->

	# ローディング表示
	$scope.loading = false

	# 表示タイプ
	$scope.mode = ''

	# 選択中のチケット
	$scope.selecting_issue = {}

	# プロジェクトID
	$scope.project_id = $stateParams.project_id

	# ユーザ一覧
	$scope.get_users = ()->
		$http(method: 'GET', url: '/get_users/'+$scope.project_id)
			.then(
				(response)->
					$scope.users = response.data.insert(null,0)
					# 未設定分を追加
			)

	# 優先度
	$scope.priorities = [
		{id: 2, name: "high"}, 
		{id: 3, name: "mid"}, 
		{id: 4, name: "low"}
	]

	# チケットの担当を変更する
	$scope.change_user = (issue,user)->
		# 変更が無い場合は終了
		if(user == null or issue.assignee == null)
			return if(user == null and issue.assignee == null)
		else if (issue.assignee.id == user.id)
			return
		# 担当者変更
		issue.assignee = user
		# 更新コマンドを作成
		command = issue.create_update_asignee_command(issue.assignee)
		commandService.store(command)

	# チケットの優先度を変更する
	$scope.change_priority = (issue,priority) ->
		# 変更が無い場合は終了
		if (issue.priority.id == priority.id)
			return
		# 担当者変更
		issue.priority = priority
		# 更新コマンドを作成
		command = issue.create_update_priority_command(issue.priority)
		commandService.store(command)


	# チケットの更新を行う
	$scope.update = () ->
		$scope.loading = true
		commandService.execute(
			()->
				# 完了メッセージを表示
				$translate('MESSAGE.UPDATE_COMPLETE').then((translation)->
					$scope.show_success(translation)
					$scope.loading = false
			  )
			,(data, status, headers, config)->
				$scope.show_error(data)
				$scope.loading = false
		)

	# 現在の表示タイプとあっているか
	$scope.active_mode = (mode) ->
		mode == $scope.mode			

	# 表示タイプを切り替える
	$scope.change_mode = (mode) ->
		# 未保存コマンドがあるか確認してから、表示切り替え
		$scope.confirm_unsave(()->
				$state.go(mode,{project_id: $scope.project_id})
			)

	# 指定のチケットを保持しているカラムを取得する
	$scope.find_column_include_issue = (issue) ->
		result = []
		for column in $scope.columns
			for _issue in column.issues
				if _issue == issue
					result.push(column)
		return result

	# チケット選択
	$scope.select_issue = (issue) ->
		$scope.selecting_issue = issue

	# エラーメッセージを表示する
	$scope.show_error = (status) ->
		$scope.$parent.show_error(status)
		$scope.loading = false

	# 完了メッセージを表示する
	$scope.show_success = (status) ->
		$scope.$parent.show_success(status)
		$scope.loading = false	

	# 未保存のコマンドがないか
	$scope.unsaved = () ->
		!(commandService.list().isEmpty())

	# チケット一覧の再読み込み
	$scope.refresh = ()->
		# 未保存コマンドがあるか確認してから、チケット読み込み
		$scope.confirm_unsave(()->
			$scope.load_tickets();
			)

	# 未保存コマンドがないか確認し、あらば確認ダイアログを表示。
	# 確認ダイアログでOKをおされれば実行
	$scope.confirm_unsave = (on_ok)->
		# 未保存コマンド確認
		if $scope.unsaved()
			# 未保存コマンドがあれば確認ダイアログを表示
			ngDialog.open({
				template: 'html/shared/confirm_dialog.html'
				controller: ['$scope',($_scope)->
					$_scope.ok= () ->
						$_scope.closeThisDialog()
						# コマンドを空にする
						commandService.clear()
						on_ok()
					$_scope.cancel= ()->
						$_scope.closeThisDialog()
				]
			})
		else
			# 未保存がないので実行
			on_ok()

)