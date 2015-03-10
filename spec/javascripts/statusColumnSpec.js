describe("StatusColumn",function(){
	var status;

	beforeEach(function(){
		data = {"id":1,"name":"未対応"};
		status = new StatusColumn(data);
	})

	describe("convert_statuses",function(){
		it("creates status",function(){
			var statuss = StatusColumn.convert_statuses([data]);
			expect(statuss[0].id).toEqual(1);
		});
	})

	describe("set_issues",function(){
		it("set related_issues", function(){
			var related_issue = new Issue(
				{"id":1070000001,"status":{"id":1}});
			var not_related_issue = new Issue(
				{"id":1070000002,"status":{"id":2}});
			status.set_issues([related_issue,not_related_issue]);
			expect(status.issues).toEqual([related_issue]);
		})
	})
})