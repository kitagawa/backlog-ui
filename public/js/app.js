var Column, Command, Issue, StatusColumn, Version, app, set_sortable, utils, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

app = angular.module('App', ['ngAnimate', 'ui.router', 'ui.sortable', 'utils', 'pascalprecht.translate', 'ngDialog']);

app.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise('/');
  return $stateProvider.state('projects', {
    url: '/',
    templateUrl: "/html/projects.html",
    controller: "projectsCtrl"
  }).state('versions', {
    url: '/:project_id',
    views: {
      '': {
        templateUrl: "/html/body.html",
        controller: "versionsCtrl"
      },
      'menu@versions': {
        templateUrl: "/html/shared/issue.html"
      },
      'list@versions': {
        templateUrl: "/html/versions.html"
      }
    }
  }).state('status', {
    url: '/:project_id/status',
    views: {
      '': {
        templateUrl: "/html/body.html",
        controller: "statusCtrl"
      },
      'menu@status': {
        templateUrl: "/html/shared/issue.html"
      },
      'list@status': {
        templateUrl: "/html/status.html"
      }
    }
  });
});

app.config([
  '$translateProvider', function($translateProvider) {
    $translateProvider.useStaticFilesLoader({
      prefix: 'locale/',
      suffix: '.json'
    });
    $translateProvider.preferredLanguage('ja');
    return $translateProvider.useMissingTranslationHandlerLog();
  }
]);

app.controller('baseCtrl', function($scope, $http, $translate, $timeout) {
  $scope.success = false;
  $scope.success_message = "";
  $scope.error = false;
  $scope.error_message = "";
  $scope.show_success = function(message) {
    $scope.success = true;
    $scope.success_message = message;
    return $timeout(function() {
      return $scope.success = false;
    }, 2000);
  };
  return $scope.show_error = function(status) {
    $scope.error = true;
    $translate('MESSAGE.CONNECTION_ERROR').then(function(translation) {
      return $scope.error_message = translation;
    });
    return $timeout(function() {
      return $scope.error = false;
    }, 2000);
  };
});

Column = (function() {
  Column.issues = [];

  function Column(attributes) {
    $.extend(this, attributes);
    this.clear();
  }

  Column.prototype.clear = function() {
    return this.issues = [];
  };

  return Column;

})();

Command = (function() {
  function Command(name, data, key) {
    this.name = name;
    this.data = data;
    this.key = key;
  }

  Command.prototype.execute = function($http, on_success, on_error) {
    var url;
    url = '/' + this.name + '/';
    if (this.key) {
      url += this.key;
    }
    return $http.post(url, this.data).success(function(data, status, headers, config) {
      return on_success(data);
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };

  Command.merge_commmand = function(command_list, command) {
    var _command, _i, _len;
    for (_i = 0, _len = command_list.length; _i < _len; _i++) {
      _command = command_list[_i];
      if (_command.name === command.name && _command.key === command.key) {
        Object.merge(_command.data, command.data);
        return;
      }
    }
    return command_list.push(command);
  };

  return Command;

})();

set_sortable = function() {
  return $(".connectedSortable").sortable({
    connectWith: ".connectedSortable"
  }).disableSelection();
};

Issue = (function() {
  function Issue(attributes) {
    $.extend(this, attributes);
  }

  Issue.prototype.due_over = function() {
    if (this.dueDate === null) {
      return false;
    }
    return new Date(this.dueDate) < new Date();
  };

  Issue.prototype.due_soon = function() {
    if (this.dueDate === null) {
      return false;
    }
    return new Date(this.dueDate) <= Date.create().addDays(3);
  };

  Issue.prototype.high_priority = function() {
    return this.priority.id === 2;
  };

  Issue.prototype.mid_priority = function() {
    return this.priority.id === 3;
  };

  Issue.prototype.low_priority = function() {
    return this.priority.id === 4;
  };

  Issue.prototype.change_status = function(status) {
    this.status.id = status.id;
    return this.status.name = status.name;
  };

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

  Issue.prototype.create_update_status_command = function(status) {
    if (status === void 0) {
      status = null;
    }
    return new Command("update_issue", {
      "statusId": status.id
    }, this.id);
  };

  Issue.find_all = function($http, project_id, on_success, on_error, option) {
    var url;
    url = '/find_issue/' + project_id;
    if (option && option['milestoneId']) {
      url += '?milestoneId=' + option['milestoneId'];
    }
    return $http({
      method: 'GET',
      url: url
    }).success(function(data, status, headers, config) {
      return on_success(Issue.convert_issues(data));
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };

  return Issue;

})();

app.controller('listBaseCtrl', function($scope, $http, $state, $stateParams, $translate, $controller, ngDialog) {
  $scope.loading = false;
  $scope.commands = [];
  $scope.mode = '';
  $scope.selecting_issue = {};
  $scope.project_id = $stateParams.project_id;
  $scope.update = function() {
    var command, commands_count, i, success_count, _i, _ref, _results;
    commands_count = $scope.commands.length;
    success_count = 0;
    _ref = $scope.commands;
    _results = [];
    for (i = _i = _ref.length - 1; _i >= 0; i = _i += -1) {
      command = _ref[i];
      $scope.loading = true;
      _results.push(command.execute($http, function(data) {
        $scope.commands.removeAt(i);
        if ($scope.commands.isEmpty()) {
          return $translate('MESSAGE.UPDATE_COMPLETE').then(function(translation) {
            return $scope.show_success(translation);
          });
        }
      }, function(data, status, headers, config) {
        return $scope.show_error(data);
      }));
    }
    return _results;
  };
  $scope.active_mode = function(mode) {
    return mode === $scope.mode;
  };
  $scope.change_mode = function(mode) {
    return $scope.confirm_unsave(function() {
      return $state.go(mode, {
        project_id: $scope.project_id
      });
    });
  };
  $scope.find_column_include_issue = function(issue) {
    var column, result, _i, _issue, _j, _len, _len1, _ref, _ref1;
    result = [];
    _ref = $scope.columns;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      column = _ref[_i];
      _ref1 = column.issues;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        _issue = _ref1[_j];
        if (_issue === issue) {
          result.push(column);
        }
      }
    }
    return result;
  };
  $scope.select_issue = function(issue) {
    return $scope.selecting_issue = issue;
  };
  $scope.show_error = function(status) {
    $scope.$parent.show_error(status);
    return $scope.loading = false;
  };
  $scope.show_success = function(status) {
    $scope.$parent.show_success(status);
    return $scope.loading = false;
  };
  $scope.unsaved = function() {
    return !($scope.commands.isEmpty());
  };
  $scope.refresh = function() {
    return $scope.confirm_unsave(function() {
      return $scope.load_tickets();
    });
  };
  return $scope.confirm_unsave = function(on_ok) {
    if ($scope.unsaved()) {
      return ngDialog.open({
        template: 'html/shared/confirm_dialog.html',
        controller: [
          '$scope', function($_scope) {
            $_scope.ok = function() {
              $_scope.closeThisDialog();
              return on_ok();
            };
            return $_scope.cancel = function() {
              return $_scope.closeThisDialog();
            };
          }
        ]
      });
    } else {
      return on_ok();
    }
  };
});

app.controller('projectsCtrl', function($scope, $http, $controller) {
  $controller('baseCtrl', {
    $scope: $scope
  });
  $scope.initialize = function() {
    return $scope.find_projects(function(data) {
      return $scope.projects = data;
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
  };
  $scope.find_projects = function(on_success, on_error) {
    return $http({
      method: 'GET',
      url: '/get_projects'
    }).success(function(data, status, headers, config) {
      return on_success(data);
    }).error(function(data, status, headers, config) {
      return on_error(data, status, headers, config);
    });
  };
  return $scope.initialize();
});

app.controller('statusCtrl', function($scope, $http, $stateParams, $translate, $controller, ngDialog) {
  $controller('listBaseCtrl', {
    $scope: $scope
  });
  $scope.mode = 'status';
  $scope.initialize = function() {
    $scope.versions = [];
    $scope.selecting_version = {};
    $scope.loading = true;
    StatusColumn.find_all($http, function(data) {
      $scope.columns = data;
      return Version.find_all($http, $stateParams.project_id, function(versions_list) {
        var selecting_version;
        $scope.versions = versions_list;
        $translate('VERSION.ALL').then(function(translation) {
          return $scope.versions.unshift(new Version({
            name: translation
          }));
        });
        selecting_version = Version.select_current(versions_list);
        return $scope.switch_version(selecting_version);
      }, function(data, status, headers, config) {
        return $scope.show_error(status);
      });
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
    return $scope.sortable_options = {
      connectWith: '.column',
      stop: function(event, ui) {
        return $scope.status_changed(ui);
      },
      receive: function(event, ui) {}
    };
  };
  $scope.status_changed = function(ui) {
    var issue, status_column;
    issue = ui.item.sortable.moved;
    if (issue === void 0) {
      return;
    }
    status_column = $scope.find_column_include_issue(issue).first();
    issue.change_status(status_column);
    return $scope.set_update_status_command(issue, status_column);
  };
  $scope.set_update_status_command = function(issue, status_column) {
    var command;
    command = issue.create_update_status_command(status_column);
    return Command.merge_commmand($scope.commands, command);
  };
  $scope.switch_version = function(version) {
    return $scope.confirm_unsave(function() {
      $scope.loading = true;
      $scope.toggle_selecting_version(version);
      return $scope.load_tickets();
    });
  };
  $scope.load_tickets = function() {
    $scope.loading = true;
    return $scope.get_issues_by_version($scope.selecting_version, function(data) {
      var column, _i, _len, _ref;
      _ref = $scope.columns;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        column = _ref[_i];
        column.clear();
        column.set_issues(data);
      }
      return $scope.loading = false;
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
  };
  $scope.toggle_selecting_version = function(version) {
    $scope.selecting_version.selected = false;
    $scope.selecting_version = version;
    return $scope.selecting_version.selected = true;
  };
  return $scope.get_issues_by_version = function(version, onSuccess, onError) {
    var option;
    option = {};
    if (version) {
      option['milestoneId'] = version.id;
    }
    return Issue.find_all($http, $stateParams.project_id, function(data) {
      return onSuccess(data);
    }, function(data, status, headers, config) {
      return onError(data, status, headers, config);
    }, option);
  };
});

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

utils = angular.module('utils', []);

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

app.controller('versionsCtrl', function($scope, $http, $stateParams, $translate, $controller, ngDialog) {
  $controller('listBaseCtrl', {
    $scope: $scope
  });
  $scope.mode = 'versions';
  $scope.initialize = function() {
    $scope.loading = true;
    Version.find_all($http, $stateParams.project_id, function(data) {
      $scope.columns = data;
      $translate('VERSION.UNSET').then(function(translation) {
        return $scope.columns.unshift(new Version({
          name: translation
        }));
      });
      return $scope.load_tickets();
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
    return $scope.sortable_options = {
      connectWith: '.column',
      stop: function(event, ui) {
        return $scope.set_update_issue_milestone(ui);
      },
      receive: function(event, ui) {}
    };
  };
  $scope.load_tickets = function() {
    $scope.loading = true;
    return Issue.find_all($http, $stateParams.project_id, function(data) {
      var version, _i, _len, _ref1;
      _ref1 = $scope.columns;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        version = _ref1[_i];
        version.clear();
        version.set_issues(data);
      }
      return $scope.loading = false;
    }, function(data, status, headers, config) {
      return $scope.show_error(status);
    });
  };
  return $scope.set_update_issue_milestone = function(ui) {
    var command, issue, versions;
    issue = ui.item.sortable.moved;
    if (issue === void 0) {
      return;
    }
    versions = $scope.find_column_include_issue(issue);
    command = issue.create_update_milestone_command(versions);
    return Command.merge_commmand($scope.commands, command);
  };
});
