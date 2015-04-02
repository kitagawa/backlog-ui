# チケットリスト基底コントローラークラス
app.controller('listBaseCtrl',($scope,$http,$stateParams,$translate,$controller,ngDialog) ->

	# ローディング表示
	$scope.loading = false

	#コマンドリスト
	$scope.commands = []
	# 表示タイプ
	$scope.mode = ''

	# 選択中のチケット
	$scope.selecting_issue = {}

	# プロジェクトID
	$scope.project_id = $stateParams.project_id

	# チケットの更新を行う
	$scope.update = () ->
		commands_count = $scope.commands.length
		success_count = 0

		for command,i in $scope.commands by -1
			$scope.loading = true
			command.execute($http,
				(data)->
					$scope.commands.removeAt(i) #実行したものは削除
					# すべてのコマンドが実行されたら完了メッセージを表示
					if $scope.commands.isEmpty()
						$translate('MESSAGE.UPDATE_COMPLETE').then((translation)->
							$scope.show_success(translation)
					  )
				,(data, status, headers, config)->
					$scope.show_error(data)
			)

	# 現在の表示タイプとあっているか
	$scope.active_mode = (mode) ->
		mode == $scope.mode			

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
		!($scope.commands.isEmpty())

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
						on_ok()
					$_scope.cancel= ()->
						$_scope.closeThisDialog()
				]
			})
		else
			# 未保存がないので実行
			on_ok()

)