function versionsCtrl($scope,$http,$routeParams){
	//バージョンの一覧を取得
	$http({method: 'GET', url: '/get_versions/'+$routeParams.project_id}).
			success(function(data, status, headers, config) {
				var versions = Version.convert_versions(data);
				//未設定用のバージョンを一覧に追加
				versions.unshift(new Version({name: "未設定"}));
				$scope.versions = versions;
				//チケットの一覧を取得
				$http({method: 'GET', url: '/find_issue/'+$routeParams.project_id}).
					success(function(data, status, headers, config) {
						//チケットにあったバージョンに配置
						var issues = Issue.convert_issues(data);
						for(i in $scope.versions){
							$scope.versions[i].set_issues(issues);
						}
						//ui-sortable.jsにあわせて配列に入れ直す
						$scope.version_rows = [];
						for(i in $scope.versions){
							$scope.version_rows.push($scope.versions[i].issues);
						}
					}).
					error(function(data, status, headers, config) {
						alert(status);
					});

			}).
			error(function(data, status, headers, config) {
				alert(status);
			});

	$scope.sortable_options = {
    connectWith: '.row',
    update: function(event,ui){
    	console.log(ui.item.sortable);
    },
    receive: function(evemt,ui){
    	// console.log(ui.ngModel);
    }
	}
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