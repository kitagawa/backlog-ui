//jqueryUIのsortableを設定する
function set_sortable(){
    $( ".connectedSortable" ).sortable({
      connectWith: ".connectedSortable"
    }).disableSelection();	
}
