# マイルストーン
class Version
	# マイルストーンに設定されているチケット一覧
	@issues: []

	constructor: (attributes) ->
		$.extend(this,attributes)
		this.issues = []

	# マイルストーンに一致するチケットを設定する
	set_issues: (issues) ->
		this.issues = [] unless this.issues?
		for issue in issues			
			this.issues.push(issue) if issue.is_include_milestone(this.id)

	#マイルストーン一覧のJSONデータからマイルストーンオブジェクトを生成する
	@convert_versions: (data_list) ->
		versions = []
		for data in data_list
			versions.push(new Version(data))
		return versions