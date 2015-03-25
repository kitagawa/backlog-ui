describe("Issue",function(){
	var issue;

	beforeEach(function(){
		data = {"id":1070000001,"milestone":[{"id":1000000001}]};
		issue = new Issue(data);
	})

	it("set attributes",function(){
		issue = new Issue({"id": 2});
		expect(issue.id).toEqual(2);
	})

	describe("due_over",function(){
		it("over",function(){
			issue.dueDate = Date.create().addDays(-1)
			expect(issue.due_over()).toBeTruthy();
		})
		it("not over",function(){
			issue.dueDate = Date.create().addDays(1)
			expect(issue.due_over()).toBeFalsy();
		})
		it("undefined", function(){
			expect(issue.due_over()).toBeFalsy();
		})		
		it("null", function(){
			issue.dueDate = null
			expect(issue.due_over()).toBeFalsy();
		})
	})

	describe("due_soon",function(){
		it("soon",function(){
			issue.dueDate = Date.create().addDays(1)
			expect(issue.due_soon()).toBeTruthy();
		})
		it("not soon",function(){
			issue.dueDate = Date.create().addDays(10)
			expect(issue.due_soon()).toBeFalsy();
		})
		it("undefined", function(){
			expect(issue.due_soon()).toBeFalsy();
		})		
		it("null", function(){
			issue.dueDate = null
			expect(issue.due_soon()).toBeFalsy();
		})
	})

	describe("change_status", function(){
		it("changed", function(){
			var issue = new Issue({"status": {"id": 1}});
			_status = new StatusColumn({"id":3, "name": "対応済み"});
			issue.change_status(_status);
			expect(issue.status.id).toEqual(3);
			expect(issue.status.name).toEqual("対応済み");
		})
	})

	describe("convert_issues",function(){
		it("creates issue",function(){
			var issues = Issue.convert_issues([data]);
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

	describe("create_update_milestone_command",function(){
		it("create_command",function(){
			milestone = data["milestone"][0]
			command = issue.create_update_milestone_command([milestone])
			expect(command).toBeTruthy
			expect(command.data["milestone_id"], [1070000001])
		})
	})
})