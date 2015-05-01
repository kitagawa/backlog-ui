app.factory('issueService', ($http)->
	# チケット一覧を取得する
	find_all:(project_id,option) ->
		url = '/find_issue/'+ project_id		
		# パラメーター設定
		if option && option['milestoneId']
			url += '?milestoneId=' + option['milestoneId'] 
			
		$http(method: 'GET', url: url).then(
			(response)->
				Issue.convert_issues(response.data)
		)
)
