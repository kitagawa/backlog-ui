describe("Version",function(){
	var version;

	beforeEach(function(){
		data = {"id":1000000001};
		version = new Version(data);
	})

	describe("convert_versions",function(){
		it("creates version",function(){
			var versions = Version.convert_versions([data]);
			expect(versions[0].id).toEqual(1000000001);
		});
	})

	describe("set_issues",function(){
		it("set related_issues", function(){
			var related_issue = new Issue(
				{"id":1070000001,"milestone":[{"id":1000000001}]});
			var not_related_issue = new Issue(
				{"id":1070000002,"milestone":[{"id":1000000002}]});
			version.set_issues([related_issue,not_related_issue]);
			expect(version.issues).toEqual([related_issue]);
		})
		it("set unsetted issues",function(){
			var none_version = new Version();
			var related_issue = new Issue(
				{"id":1070000001});
			var not_related_issue = new Issue(
				{"id":1070000002,"milestone":[{"id":1000000001}]});
			none_version.set_issues([related_issue,not_related_issue]);
			expect(none_version.issues).toEqual([related_issue]);
		})
	})
})