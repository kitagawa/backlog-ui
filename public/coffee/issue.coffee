class Issue
	constructor: (attributes) ->
		$.extend(this,attributes)
	is_include_milestone: (version_id) ->
		if this.milestones
			for milestone in this.milestones 
				if milestone.id == version_id
					return true
		else
			if version_id == null
				return true
		return false
		
	@convert_issues: (data_list) ->
		issues = []
		for data in data_list
			issues.push(new Issue(data))
		return issues