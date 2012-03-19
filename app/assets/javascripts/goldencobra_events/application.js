// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

$(document).ready(function() {
	
	// Nur einmal die Info zu den Anmeldeoptionen anzeigen
	$(".reg_info:gt(0)").hide()
	
	//Initialize popup for event Registration: Select of Pricegroup
	$('body').append("<div id='goldencobra_events_event_popup' style='display:none'></div>");
	$('#goldencobra_events_event_popup').overlay({
		fixed:false,
		mask:{
				color: '#ebecff',
				loadSpeed: 200,
				opacity: 0.9
			},
		closeOnClick: true
	});
	$('#goldencobra_events_event_popup a.close').live("click", function(){
		$('#goldencobra_events_event_popup').overlay().close();
		return false;
	});
	$('#goldencobra_events_enter_account_data_form div.next_step a').live("click", function(){
		$('#goldencobra_events_enter_account_data_form ul a.current').parent().next().find("a").trigger("click");
		return false;
	});
	

	// $('#goldencobra_events_user_registration_form').validator();
	
	//Event Registration site	
	//$('#goldencobra_events_article_events li .article_event_content .title').bind("click", function(){
	//	$(this).closest("li").children("ul").slideToggle("fast");
	//	$(this).toggleClass("active");
	//});
	//$('#goldencobra_events_article_events .article_event_content .title').trigger("click");

  $('.register_for_event_checkbox').bind("click", function() {
    id = $(this).attr("data-id")
    $("a#register_for_event_" + id + "_link").trigger("click")
    $(this).parent().parent().siblings().children().children("input").hide();
    $(this).parent().find(".title").append(' (vorgemerkt)');
	$(this).hide();
  });
	
	$('#goldencobra_events_enter_account_data').bind("click", function(){
		$('#goldencobra_events_enter_account_data_form').fadeIn();
		$("#goldencobra_events_enter_account_data_form ul.tabs").tabs("div.panes > fieldset", {effect: 'fade', fadeInSpeed: 400});
	});
	
	// Mit Anmeldung fortfahren und DIVs darüber ausblenden
	$('#goldencobra_events_enter_account_data').live("click", function() {
		$('#goldencobra_events_article_events').fadeOut('slow');
    $('#goldencobra_events_enter_account_data').fadeOut('slow');
    $('#article_event_webcode_form').fadeOut('slow');
	});
	
});
