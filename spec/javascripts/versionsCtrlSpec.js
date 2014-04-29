describe("versionsCtrl",function(){
	var versions;
	var issues;
	var versionCtrl;
	var scope;

	beforeEach(function(){
		var version_datas = [
		{"id":1000000001,"name":"スプリント1","date":"20130902"},
		{"id":1000000002,"name":"スプリント2","date":"20130909"},
		{"id":1000000003,"name":"スプリント3","date":"20130916"},
		{"id":1000000004,"name":"スプリント4","date":"20130923"},
		]
		var issues_dates = [
		{"id":1070000001,"milestones":[{"id":1000000001}]},
		{"id":1070000002,"milestones":[{"id":1000000002}]},
		{"id":1070000003,"milestones":[{"id":1000000002}]},
		{"id":1070000004},
		]

		versions = Version.convert_versions(version_datas);
		issues = Issue.convert_issues(issues_dates);
	})

	beforeEach(module("App"));	
	beforeEach(inject(function($controller){
		scope = {versions:versions};
		versionCtrl = $controller("versionsCtrl",{$scope:scope});
	}))
	
	describe("find_version_included_issue",function(){
		it("create issue", function(){
			var issue = issues[0];
			scope.versions[0].issues.push(issue);
			scope.versions[1].issues.push(issue);
			expect(scope.find_version_included_issue(issue)).toEqual([scope.versions[0],scope.versions[1]]);
		})
	})
})

