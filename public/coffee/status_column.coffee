# 状態
class StatusColumn extends Column
	#状態一覧のJSONデータからオブジェクトを生成する
	# @param 生成元のデータリスト
	# @return 状態リスト
	@convert_statuses: (data_list) ->
		statuses = []
		for data in data_list
			statuses.push(new StatusColumn(data))
		return statuses

	set_issues: (issues)->
		this.issues = [] unless this.issues?
		for issue in issues			
			this.issues.push(issue) if issue.status && issue.status.id == this.id