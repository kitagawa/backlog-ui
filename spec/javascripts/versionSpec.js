describe("Version",function(){
	var version;

	beforeEach(function(){
		data = {
			"id":1000000001, 
			"startDate":"2014-03-23T00:00:00Z",
			"releaseDueDate": "2014-04-23T00:00:00Z"
		};
		data2 = {
			"id": 1000000002, 
			"startDate":"2014-04-23T00:00:00Z",
			"releaseDueDate": "2014-05-23T00:00:00Z"
		};
		version = new Version(data);
		version2 = new Version(data2);
		data3 = {
			"id": 1000000003, 
			"startDate":"2014-05-23T00:00:00Z",
			"releaseDueDate": "2014-06-23T00:00:00Z"
		};
		version = new Version(data);
		version2 = new Version(data2);
		version3 = new Version(data3);
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

	describe("select_current", function(){
		it("get nearest release due version in term", function(){
			var selected = Version.select_current([version,version2,version3],new Date("2014/5/20"));
			expect(selected).toEqual(version2);
		})
		it("get nearest start version", function(){
			var selected = Version.select_current([version,version2,version3],new Date("2014/1/20"));
			expect(selected).toEqual(version);
		})
		it("get nearest release due version", function(){
			version.startDate = null;
			version2.startDate = null;
			version3.startDate = null;
			var selected = Version.select_current([version,version2,version3],new Date("2014/1/20"));
			expect(selected).toEqual(version);
		})
		it("get nearest started version", function(){
			version.releaseDueDate = null;
			version2.releaseDueDate = null;
			version3.releaseDueDate = null;
			var selected = Version.select_current([version,version2,version3],new Date("2014/8/20"));
			expect(selected).toEqual(version3);
		})

		it("get nearest started version", function(){
			version.startDate = null;
			version2.startDate = null;
			version3.startDate = null;
			var selected = Version.select_current([version,version2,version3],new Date("2014/8/20"));
			expect(selected).toEqual(null);
		})

	})
})