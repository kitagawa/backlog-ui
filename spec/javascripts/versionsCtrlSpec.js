describe("versionsCtrl",function(){
	var version_dates;
	var issues;

	beforeEach(function(){
		version_dates = [
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

		issues = Issue.convert_issues(issues_dates);
	})

	describe("filter_milestone",function(){
		it("get filtered issues",function(){
			var filtered_issues = filter_milestone(issues,1000000001);
			expect(filtered_issues.length).toEqual(1);
			expect(filtered_issues[0].id,1070000001);
		})
		it("get issues which not has milestones",function(){
			var filtered_issues = filter_milestone(issues,null);
			expect(filtered_issues.length).toEqual(1);
			expect(filtered_issues[0].id,1070000004);
		})
	})
})

