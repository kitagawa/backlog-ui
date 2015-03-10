var Column;

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
