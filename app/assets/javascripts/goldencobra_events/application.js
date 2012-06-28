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

  $('.register_for_event_checkbox').bind("click", function() {
    id = $(this).attr("data-id")
    $("a#register_for_event_" + id + "_link").trigger("click")
    $(this).parent().find(".title").append(' (vorgemerkt)');
  });
	
	// Mit Anmeldung fortfahren und DIVs darüber ausblenden
	$('#goldencobra_events_enter_account_data').live("click", function() {
		$('#goldencobra_events_article_events').fadeOut('slow');
    	$('#goldencobra_events_enter_account_data').fadeOut('slow');
    	$('#article_event_webcode_form').fadeOut('slow');
    	$('#goldencobra_events_enter_account_data_form').fadeIn();
	});
	
  $('#goldencobra_events_user_registration_form_submit').bind("click", function(){
    $('.validation_error').each(function() { $(this).remove();});
    var gender_selection = false;
    var male = $("#male");
    var female = $("#female");
    var male_result = (male.attr("checked") != "undefined" && male.attr("checked") == "checked");
    var female_result = (female.attr("checked") != "undefined" && female.attr("checked") == "checked");
    
    if (male_result == false && female_result == false) {
      $("#female").parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 280px;'>Pflichtangabe</p>");
    }
    
    if ($('#registration_user_firstname').attr('value') == '') {
      $('#registration_user_firstname').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
    }
    
    if ($('#registration_user_lastname').attr('value') == '') {
      $('#registration_user_lastname').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
    }
    
    if ($('#registration_company_location_attributes_street').attr('value') == '') {
      $('#registration_company_location_attributes_street').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
    }

    var zipReg = /^\d{5}$/;
    if (!zipReg.test($('#registration_company_location_attributes_zip').attr('value'))) {
      $('#registration_company_location_attributes_city').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe. Bitte 5 stellige Postleitzahl angeben.</p>");
    }
    
    if ($('#registration_company_location_attributes_city').attr('value') == '') {
      $('#registration_company_location_attributes_city').append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
    }
    
    var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    if ($('#registration_user_email').attr('value') == '') {
      $('#registration_user_email').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Pflichtangabe</p>");
    }
    else if(!emailReg.test($('#registration_user_email').attr('value'))) {
      $('#registration_user_email').parent().append("<p class='validation_error' style='color:red; margin: -20px 0 0 480px;'>Email nicht gültig</p>");
    }
    
    if ($('#AGB_accepted').attr('checked') != "checked") {
      $('#AGB_accepted').parent().append("<p class='validation_error' style='color:red; margin: -18px 0 0 480px;'>Pflichtangabe</p>");
    }

  });
});
