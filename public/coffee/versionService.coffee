app.factory('versionService', ($http)->
	# マイルストーンの一覧を取得する
	find_all:(project_id) ->
		$http(method: 'GET', url: '/get_versions/'+project_id)
		.then(
			(response)->
				Version.convert_versions(response.data)
		)
)
