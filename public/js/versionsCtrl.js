function versionsCtrl($scope,$http,$routeParams){
	//バージョンの一覧を取得
	$http({method: 'GET', url: '/get_versions/'+$routeParams.project_id}).
			success(function(data, status, headers, config) {
				$scope.versions = data;
				$http({method: 'GET', url: '/find_issue/'+$routeParams.project_id}).
					success(function(data, status, headers, config) {
						$scope.issues = Issue.set_issues(data);
					}).
					error(function(data, status, headers, config) {
						alert(status);
					});
			}).
			error(function(data, status, headers, config) {
				alert(status);
			});
}

app.filter('milestoneFilter',function(){
	return function(items,version_id){
		var filtered_issues = filter_milestone(items,version_id);
		return filtered_issues;
	}
});

//指定のバージョンを持ったチケットをとりだす
function filter_milestone(issues,version_id){
	var filtered_issues = [];
	var issue;
	for(i in issues){
		issue = issues[i];
		if(issue.is_include_milestone(version_id)){
			filtered_issues.push(issue);
		}
	}
	return filtered_issues;
}
