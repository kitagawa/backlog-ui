# チケット
class Issue

	# コンストラクタ
	# @param attributes 属性
	constructor: (attributes) ->
		$.extend(this,attributes)
	
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