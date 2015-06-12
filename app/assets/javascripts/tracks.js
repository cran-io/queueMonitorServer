// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  begin_date = $('#start').val();
  end_date = $('#end').val();
  date = $('#stats-datepicker').find('input').val();
  set_range_percentage_chart(begin_date, end_date);
  set_table_chart(date);
  get_day();  

  $('.close').click(function(){
    $('#hour-panel-container').hide();
  });

  $('#range-datepicker').datepicker({
      format: 'dd/mm/yyyy',
      language: 'es',
      endDate: '0',
      startDate: '-1m' 
  });


  $('#stats-datepicker').datepicker({
    format: 'dd/mm/yyyy',
    language: 'es',
    endDate: '0',
    startDate: '-1m',
    autoclose: true
  }).on('hide', function(){
    var date = $('#stats-datepicker').find('input').val();
    refresh_table(date);
    set_table_chart(date);
  });

  $('#filter').click(function(){
    begin_date = $('#start').val();
    end_date = $('#end').val();
    refresh_pulse_chart(begin_date, end_date);
    refresh_pulse_head(begin_date, end_date);
    set_range_percentage_chart(begin_date, end_date);
  });


  setInterval(function(){
    begin_date = $('#start').val();
    end_date = $('#end').val();
    refresh_pulse_chart(begin_date, end_date);
    set_range_percentage_chart(begin_date, end_date);
  }, 30000);
  
});


function set_table_chart(date){
  data = {
    date: date
  }
  $.ajax({
    type: 'GET',
    url: '/table_chart_data.json',
    data: data,
    success: function(response){
      line_chart(response, 'table_chart', 'hour');
    }
  });
}

function set_range_percentage_chart(begin_date, end_date){ 
  data = { 
    begin_date: begin_date, 
    end_date: end_date 
  }
  $.ajax({
    type: 'GET',
    url: '/range_chart_data.json',
    data: data,
    success: function(response){
      line_chart(response, 'range_percentage_chart');
    }
  });
}

function get_day(){
  $('.hour').click(function(){
    var hour_values = $(this).data('hour');
    var hour_range = $(this).data('range') + "hs - " + (parseInt($(this).data('range'))+1) + "hs"
    var title = $(this).data("day") + " | " + hour_range;
    $.ajax({
      type: 'GET',
      url: '/show_hour',
      data: {hour: hour_values},
      success: function(response){
        $('#clicked-day').html(response);
        $('#clicked-day').find('.progress').first().addClass('bigger');
        $('#hour-panel-container').fadeIn(function(){
        });
        $('#clicked-day-head').html(title)
      }
    }); 
  });
}

function refresh_table(date){
  data = {
    date: date
  }
  $.ajax({
    type: 'GET',
    url: 'refresh_table',
    data: data,
    success: function(response){
      $('#comparison-table-container').html(response);
    }
  });
}

function refresh_pulse_chart(begin_date, end_date){
  data = { 
    begin_date: begin_date, 
    end_date: end_date 
  };
  $.ajax({
    type: 'GET',
    url: '/refresh_pulse_chart',
    data: data,
    success: function(response){
      $('#days').html(response);
      get_day();
    }
  });
}

function refresh_pulse_head(begin_date, end_date){
  $.ajax({
    type: 'GET',
    url: '/refresh_head',
    data: { 
      begin_date: begin_date, 
      end_date: end_date 
    },
    success: function(response){
      $('#head').html(response);
    }
  });
}