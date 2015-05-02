// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
	$('.close').click(function(){
		$('#hour-panel-container').hide();
	})
	get_day();
	$('#datepicker').datepicker({
	    format: "dd/mm/yyyy",
	    language: "es",
	    endDate: '0',
		startDate: '-1m' 
	});

	$('#search').click(function(){
		begin_date = $('#start').val();
		end_date = $('#end').val();
		refresh_chart(begin_date, end_date);
		refresh_head(begin_date, end_date);
	});

	setInterval(function(){
		begin_date = $('#start').val();
		end_date = $('#end').val();
		refresh_chart(begin_date, end_date);
 	}, 30000);
 	
});

function get_day(){
	$('.hour').click(function(){
		var data = $(this).data('hour');
		$.ajax({
			type: 'GET',
			url: '/show_hour',
			data: {hour: data},
			success: function(response){
				$('#clicked-day').html(response);
				$('#clicked-day').find('.progress').first().addClass('bigger');
				$('#hour-panel-container').fadeIn(function(){
				});
			}
		});	
	});
}
function refresh_chart(begin_date, end_date){
	data = { begin_date: begin_date, end_date: end_date };
	$.ajax({
		type: 'GET',
		url: '/refresh',
		data: data,
		success: function(response){
			$('#days').html(response);
			get_day();
		}
	});
}

function refresh_head(begin_date, end_date){
	$.ajax({
		type: 'GET',
		url: '/refresh_head',
		data: { begin_date: begin_date, end_date: end_date },
		success: function(response){
			$('#head').html(response);
		}
	});
}