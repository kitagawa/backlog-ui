# マイルストーン
class Version extends Column
		# コンストラクタ
	# @param 属性
	constructor: (attributes) ->
		super(attributes)
		# 日付型の変更
		this.startDate = new Date(attributes["startDate"]) if attributes
		this.releaseDueDate = new Date(attributes["releaseDueDate"]) if attributes

	# マイルストーン一覧を取得する
	@find_all:($http, project_id, on_success, on_error) ->
		$http(method: 'GET', url: '/get_versions/'+project_id)
		.success (data, status, headers, config)->
			on_success(Version.convert_versions(data))
		.error (data, status, headers, config)->
			on_error(data, status, headers, config)

	# マイルストーンに一致するチケットを設定する
	# @param issues チケットの一覧
	set_issues: (issues) ->
		this.issues = [] unless this.issues?
		for issue in issues			
			this.issues.push(issue) if issue.is_include_milestone(this.id)

	# マイルストーンの一覧の中から現在進行中のマイルストーンを一つ取得する
	# @param versions マイルストーンの一覧
	# @param target_date 現在日、指定がなければ自動で当日が設定
	@select_current: (versions,target_date) ->
		selected = null
		# 期間中で期日が直近のマイルストーンを返す
		for version in versions
			continue if version.startDate == null || version.releaseDueDate == null || version.startDate > target_date
			if version.releaseDueDate >= target_date
				if selected == null || version.releaseDueDate < selected.releaseDueDate
					selected = version
		return selected if selected 

		#期間内にあるマイルストーンがない場合
		#直近で始まるマイルストーンを返す
		for version in versions
			continue if version.startDate == null || version.startDate < target_date
			if selected == null || version.startDate < selected.startDate
					selected = version
		return selected	if selected 

		#直近で始まるマイルストーンもない場合
		#直近の期日のマイルストーンを返す
		for version in versions
			continue if version.releaseDueDate == null || version.releaseDueDate < target_date
			if selected == null || version.releaseDueDate < selected.releaseDueDate
					selected = version
		return selected	if selected 

		#直近の期日のマイルストーンもない場合
		#直近で始まったマイルストーンで期日が設定されていないものを返す
		for version in versions
			continue if version.startDate == null
			if selected == null || version.startDate > selected.startDate
					selected = version
		return selected	if selected

		#それ以外はnullを返す
		return null
			
	
	#マイルストーン一覧のJSONデータからマイルストーンオブジェクトを生成する
	# @param 生成元のデータリスト
	# @return マイルストーンリスト
	@convert_versions: (data_list) ->
		versions = []
		for data in data_list
			versions.push(new Version(data))
		return versions