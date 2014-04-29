# チケット
class Issue

	constructor: (attributes) ->
		$.extend(this,attributes)
	
	# マイルストーンが一致しているかを返す
	is_include_milestone: (version_id) ->
		if this.milestones
			for milestone in this.milestones 
				if milestone.id == version_id
					return true
		else				
		# マイルストーンが設定されていない場合、version_idがnullなら一致
			return true unless version_id?
		return false
		
	# チケットのJSONデータからチケットオブジェクトを生成する
	@convert_issues: (data_list) ->
		issues = []
		for data in data_list
			issues.push(new Issue(data))
		return issues

	# 設定されているマイルストーンを更新する
	update_milestone: ($http,milestones) ->
		milestone_id_list = milestones.map((n)->n.id)
		data = {milestoneId: milestone_id_list}
		$http.post('/update_issue/'+this.key,data)