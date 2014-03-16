class Version
	@issues: []

	constructor: (attributes) ->
		$.extend(this,attributes)

	set_issues: (issues) ->
		this.issues = [] unless this.issues?
		for issue in issues
			if issue.is_include_milestone(this.id)
				this.issues.push(issue)

	@convert_versions: (data_list) ->
		versions = []
		for data in data_list
			versions.push(new Version(data))
		return versions