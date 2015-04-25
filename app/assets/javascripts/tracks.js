// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
	$('body').click(function(){
		
	});

	setInterval(function(){
		$.ajax({
			type: 'GET',
			url: '/refresh',
			success: function(response){
				$('#days').html(response);
			}
		});
 	}, 30000);
 	
});