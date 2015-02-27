var Version,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Version = (function(_super) {
  __extends(Version, _super);

  function Version(attributes) {
    Version.__super__.constructor.call(this, attributes);
    if (attributes) {
      this.startDate = new Date(attributes["startDate"]);
    }
    if (attributes) {
      this.releaseDueDate = new Date(attributes["releaseDueDate"]);
    }
  }

  Version.find_all = function($http, project_id, on_success, on_error) {
    return $http({
      method: 'GET',
      url: '/get_versions/' + project_id
    }).success(function(data, status, headers, config) {
      return on_success(Version.convert_versions(data));
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };

  Version.prototype.set_issues = function(issues) {
    var issue, _i, _len, _results;
    if (this.issues == null) {
      this.issues = [];
    }
    _results = [];
    for (_i = 0, _len = issues.length; _i < _len; _i++) {
      issue = issues[_i];
      if (issue.is_include_milestone(this.id)) {
        _results.push(this.issues.push(issue));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Version.select_current = function(versions, target_date) {
    var selected, version, _i, _j, _k, _l, _len, _len1, _len2, _len3;
    selected = null;
    for (_i = 0, _len = versions.length; _i < _len; _i++) {
      version = versions[_i];
      if (version.startDate === null || version.releaseDueDate === null || version.startDate > target_date) {
        continue;
      }
      if (version.releaseDueDate >= target_date) {
        if (selected === null || version.releaseDueDate < selected.releaseDueDate) {
          selected = version;
        }
      }
    }
    if (selected) {
      return selected;
    }
    for (_j = 0, _len1 = versions.length; _j < _len1; _j++) {
      version = versions[_j];
      if (version.startDate === null || version.startDate < target_date) {
        continue;
      }
      if (selected === null || version.startDate < selected.startDate) {
        selected = version;
      }
    }
    if (selected) {
      return selected;
    }
    for (_k = 0, _len2 = versions.length; _k < _len2; _k++) {
      version = versions[_k];
      if (version.releaseDueDate === null || version.releaseDueDate < target_date) {
        continue;
      }
      if (selected === null || version.releaseDueDate < selected.releaseDueDate) {
        selected = version;
      }
    }
    if (selected) {
      return selected;
    }
    for (_l = 0, _len3 = versions.length; _l < _len3; _l++) {
      version = versions[_l];
      if (version.startDate === null) {
        continue;
      }
      if (selected === null || version.startDate > selected.startDate) {
        selected = version;
      }
    }
    if (selected) {
      return selected;
    }
    return null;
  };

  Version.convert_versions = function(data_list) {
    var data, versions, _i, _len;
    versions = [];
    for (_i = 0, _len = data_list.length; _i < _len; _i++) {
      data = data_list[_i];
      versions.push(new Version(data));
    }
    return versions;
  };

  return Version;

})(Column);
