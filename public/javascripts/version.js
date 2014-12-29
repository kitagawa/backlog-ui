var Version;

Version = (function() {
  Version.issues = [];

  function Version(attributes) {
    $.extend(this, attributes);
    this.issues = [];
  }

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

})();
