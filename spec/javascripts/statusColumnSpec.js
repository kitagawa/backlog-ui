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

	// describe("set_issues",function(){
	// 	it("set related_issues", function(){
	// 		var related_issue = new Issue(
	// 			{"id":1070000001,"milestone":[{"id":1000000001}]});
	// 		var not_related_issue = new Issue(
	// 			{"id":1070000002,"milestone":[{"id":1000000002}]});
	// 		version.set_issues([related_issue,not_related_issue]);
	// 		expect(version.issues).toEqual([related_issue]);
	// 	})
	// 	it("set unsetted issues",function(){
	// 		var none_version = new Version();
	// 		var related_issue = new Issue(
	// 			{"id":1070000001});
	// 		var not_related_issue = new Issue(
	// 			{"id":1070000002,"milestone":[{"id":1000000001}]});
	// 		none_version.set_issues([related_issue,not_related_issue]);
	// 		expect(none_version.issues).toEqual([related_issue]);
	// 	})
	// })
})