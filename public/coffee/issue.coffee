# チケット
class Issue
	# コンストラクタ
	# @param attributes 属性
	constructor: (attributes) ->
		$.extend(this,attributes)

	# 期限をすぎているか
	# @return boolean
	due_over: () ->
		return false if this.dueDate == null
		new Date(this.dueDate) < new Date()

	# 期限が近いか
	# 3日前ならtrue
	# @return boolean
	due_soon: () ->
		return false if this.dueDate == null
		new Date(this.dueDate) <= Date.create().addDays(3)

	# 高優先度
	# @return boolean
	high_priority: () ->
		this.priority.id == 2 

	# 中優先度
	# @return boolean
	mid_priority: () ->
		this.priority.id == 3

	# 高優先度
	# @return boolean
	low_priority: () ->
		this.priority.id == 4 


	# マイルストーンが一致しているかを返す
	# @param version_id 検索するマイルストーンのID
	# @return boolean
	is_include_milestone: (version_id) ->
		if this.milestone && !this.milestone.isEmpty()
			for milestone in this.milestone
				if milestone.id == version_id
					return true
		else				
		# マイルストーンが設定されていない場合、version_idがnullなら一致
			return true unless version_id?
		return false
		
	# チケットのJSONデータからチケットオブジェクトを生成する
	# @param data_list 生成元のデータリスト
	# @return チケットのリスト
	@convert_issues: (data_list) ->
		issues = []
		for data in data_list
			issues.push(new Issue(data))
		return issues

	#マイルストーン更新コマンドを作成する
	# @param milestones 変更先のマイルストーン一覧
	# @return 更新コマンド
	create_update_milestone_command: (milestones) ->		
		milestone = milestones.map((n)->n.id).first() #先頭一つのみを使う
		#TODO 複数対応 milestoneId[indexを入れる]
		milestone = null if milestone == undefined
		new Command("update_issue", {
			"milestoneId[]": milestone
			},this.id)

	#ステータス更新コマンドを作成する
	# @param status 変更先のステータス一覧
	# @return 更新コマンド
	create_update_status_command: (status) ->		
		status = null if status == undefined
		new Command("update_issue", {
			"statusId": status.id
			},this.id)


	# チケットの一覧を取得する
	@find_all:($http, project_id, on_success, on_error,option) ->
		url = '/find_issue/'+ project_id		
		# パラメーター設定
		if option && option['milestoneId']
			url += '?milestoneId=' + option['milestoneId'] 
			
		$http(method: 'GET', url: url)
		.success (data, status, headers, config) ->		
			on_success(Issue.convert_issues(data))
		.error (data, status, headers, config)->
			on_error(data, status, headers, config)
