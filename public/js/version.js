function Version(attriubtes){
	$.extend(this,attriubtes)
}

Version.convert_versions = function(data){
	versions = [];
	for(i in data){
		versions.push(new Version(data[i]));
	}
	return versions;
}

//同じマイルストーンを持つチケットを設定する
Version.prototype.set_issues = function(issues){
	if(this.issues == null){
		this.issues = [];
	}
	for (i in issues){
		var issue = issues[i];
		if (issue.is_include_milestone(this.id)){
			this.issues.push(issue);
		}
	}
};
