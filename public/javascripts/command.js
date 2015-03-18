var Command;

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
