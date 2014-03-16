versionsCtrl = ($scope,$http,$routeParams) ->
 	$http(method: 'GET', url: '/get_versions/'+$routeParams.project_id)
		.success (data, status, headers, config)->
			versions = Version.convert_versions(data)
			# 未設定用のバージョンを一覧に追加
			versions.unshift(new Version(name: "未設定"))
			$scope.versions = versions;
			# # チケットの一覧を取得
			$http(method: 'GET', url: '/find_issue/'+$routeParams.project_id)
			.success (data, status, headers, config) ->
				# チケットにあったバージョンに配置
				issues = Issue.convert_issues(data)
				for version in $scope.versions
				 	version.set_issues(issues)
				# ui-sortable.jsにあわせて配列に入れ直す
				$scope.version_rows = []
				for version in $scope.versions
				  $scope.version_rows.push(version.issues)
			.error (data, status, headers, config)->
					alert status
		.error (data, status, headers, config)->
			alert status
		$scope.sortable_options =
			connectWith: '.row',
			update: (event,ui) ->
			receive: (evemt,ui) ->

app.filter('milestoneFilter',()->
	(items,version_id) ->
		filtered_issues = filter_milestone(items,version_id)
		return filtered_issues
)

# 指定のバージョンを持ったチケットをとりだす
filter_milestone = (issues,version_id) ->
	filtered_issues = []
	issue
	for issue in issues
		if issue.is_include_milestone(version_id)
			filtered_issues.push(issue)
	return filtered_issues