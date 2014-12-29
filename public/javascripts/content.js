var set_sortable;

set_sortable = function() {
  return $(".connectedSortable").sortable({
    connectWith: ".connectedSortable"
  }).disableSelection();
};
