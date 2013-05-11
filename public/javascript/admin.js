// REF http://stackoverflow.com/questions/2672355/calling-jquery-method-from-onclick-attribute-in-html answered Apr 20 '10 at 3:40
function showMessage(msg) {
   alert(msg + " => Shown");
   // alert(msg);
};

$(document).ready(function(){
  $("p").click(function(){
    // $(this).hide();
    
    // REF css() http://stackoverflow.com/questions/12197828/how-to-set-style-display-of-an-html-element answered Aug 30 '12 at 13:22
    // REF http://api.jquery.com/css/
    $(this).css("background-color", "blue");
  });
  
  $("#show_button").click(function(){

    $("#logs").show();

    // REF disabled http://stackoverflow.com/questions/5580616/jquery-change-button-text
    $(this).attr("disabled", true);
    
    // REF disabled http://d.hatena.ne.jp/ogakky/20110711/1310349297
    $(".hide_button").removeAttr("disabled");
    
    
    // $("#logs").css("visibility", "visible");
  });
  
  $(".hide_button").click(function(){

    // alert($(this).attr("value"));

	// REF visibility http://www.htmq.com/style/visibility.shtml
    // $("#logs").css("visibility", "hide");
    $("#logs").hide();
    
    $(this).attr("disabled", true);
    $("#show_button").removeAttr("disabled");
    
  });
  
  $("#item_refactor_table_word_lists").click(function(){

    // alert($(this).css("value"));
    // alert($(this).attr("value"));

    
  });
  
  // 
  
});