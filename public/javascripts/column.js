var Column;

Column = (function() {
  Column.issues = [];

  function Column(attributes) {
    $.extend(this, attributes);
    this.issues = [];
  }

  return Column;

})();
