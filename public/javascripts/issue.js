var Issue;

Issue = (function() {
  function Issue(attributes) {
    $.extend(this, attributes);
  }

  Issue.prototype.is_include_milestone = function(version_id) {
    var milestone, _i, _len, _ref;
    if (this.milestone && !this.milestone.isEmpty()) {
      _ref = this.milestone;
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

  Issue.prototype.create_update_milestone_command = function(milestones) {
    var milestone;
    milestone = milestones.map(function(n) {
      return n.id;
    }).first();
    if (milestone === void 0) {
      milestone = null;
    }
    return new Command("update_issue", {
      "milestoneId[]": milestone
    }, this.id);
  };

  return Issue;

})();
