var StatusColumn, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

StatusColumn = (function(_super) {
  __extends(StatusColumn, _super);

  function StatusColumn() {
    _ref = StatusColumn.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  StatusColumn.find_all = function($http, on_success, on_error) {
    return $http({
      method: 'GET',
      url: '/get_statuses'
    }).success(function(data, status, headers, config) {
      return on_success(StatusColumn.convert_statuses(data));
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };

  StatusColumn.convert_statuses = function(data_list) {
    var data, statuses, _i, _len;
    statuses = [];
    for (_i = 0, _len = data_list.length; _i < _len; _i++) {
      data = data_list[_i];
      statuses.push(new StatusColumn(data));
    }
    return statuses;
  };

  StatusColumn.prototype.set_issues = function(issues) {
    var issue, _i, _len, _results;
    if (this.issues == null) {
      this.issues = [];
    }
    _results = [];
    for (_i = 0, _len = issues.length; _i < _len; _i++) {
      issue = issues[_i];
      if (issue.status && issue.status.id === this.id) {
        _results.push(this.issues.push(issue));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  return StatusColumn;

})(Column);
