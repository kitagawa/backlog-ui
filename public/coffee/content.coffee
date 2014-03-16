# jqueryUIのsortableを設定する
set_sortable = () ->
    $( ".connectedSortable" ).sortable(
      connectWith: ".connectedSortable"
    ).disableSelection()
