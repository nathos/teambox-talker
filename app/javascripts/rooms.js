$(function() {
  
  $("#room a#edit").click(function() {
    $("#room").hide();
    $("#edit_room").show();
    return false;
  });
  $("#edit_room form").
    submitWithAjax().
    find("a.cancel").click(function() {
      $("#room").show();
      $("#edit_room").hide();
      return false;
    });
  
});