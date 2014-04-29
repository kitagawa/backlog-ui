var Issue;

Issue = (function() {
  function Issue(attributes) {
    $.extend(this, attributes);
  }

  Issue.prototype.is_include_milestone = function(version_id) {
    var milestone, _i, _len, _ref;
    if (this.milestones) {
      _ref = this.milestones;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        milestone = _ref[_i];
        if (milestone.id === version_id) {
          return true;
        }
      }
    } else {
      if (version_id == null) {
        return true;
      }
    }
    return false;
  };

  Issue.convert_issues = function(data_list) {
    var data, issues, _i, _len;
    issues = [];
    for (_i = 0, _len = data_list.length; _i < _len; _i++) {
      data = data_list[_i];
      issues.push(new Issue(data));
    }
    return issues;
  };

  Issue.prototype.update_milestone = function($http, milestones) {
    var data, milestone_id_list;
    console.log(milestones);
    milestone_id_list = milestones.map(function(n) {
      return n.id;
    });
    console.log(milestone_id_list);
    data = {
      milestoneId: milestone_id_list
    };
    return $http.post('/update_issue/' + this.key, data);
  };

  return Issue;

})();
