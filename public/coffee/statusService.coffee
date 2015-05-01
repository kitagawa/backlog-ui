app.factory('statusService', ($http)->
	# ステータスの一覧を取得する
	find_all: () ->
		$http(method: 'GET', url: '/get_statuses')
		.then(
			(response)->
				StatusColumn.convert_statuses(response.data)
		)
)
