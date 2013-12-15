describe("Issue",function(){
	var issue;

	beforeEach(function(){
		data = {"id":1070000001,"milestones":[{"id":1000000001}]};
		issue = new Issue(data);
	})

	it("set attributes",function(){
		issue = new Issue({"id": 2});
		expect(issue.id).toEqual(2);
	})

	describe("set_issues",function(){
		it("creates issue",function(){
			var issues = Issue.set_issues([data]);
			expect(issues[0].id).toEqual(1070000001);
		});
	})

	describe('is_include_milestone', function() {
		it("include a milestone",function(){
			expect(issue.is_include_milestone(1000000001)).toBeTruthy();
		})
		it("not include a milestone",function(){
			expect(issue.is_include_milestone(1000000002)).toBeFalsy();
		})
		it("get issues without milestone",function(){
			issue_with_no_milestone = new Issue({"id":1070000001});
			expect(issue_with_no_milestone.is_include_milestone(null)).toBeTruthy();
		})
	})

})