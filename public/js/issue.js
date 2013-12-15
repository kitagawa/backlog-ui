function Issue(attriubtes){
	$.extend(this,attriubtes)
}

Issue.set_issues = function(data){
	issues = [];
	for(i in data){
		issues.push(new Issue(data[i]));
	}
	return issues;
}
	
//同じバージョンであるか返す
//nullを指定した場合は、milestoneが指定されていなければtrue
Issue.prototype.is_include_milestone = function(version_id){
	if(this.milestones){
		for(i in this.milestones){
			if(this.milestones[i].id == version_id){
				return true;
			}
		}
	}else{
		if(version_id == null){
			return true;
		}
	}
	return false;
};
