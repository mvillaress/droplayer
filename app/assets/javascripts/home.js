// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  function refreshList(data){
    $('#mylist').html('');
    var song;
    $.each(data, function(ind, el){
      song = $('<li>'+el.path+'</el>');
      song.data('song', el);
      song.appendTo('#mylist')
    });
  }
  
  $('#mylist').on('click', 'li', function(ev){
    var song = $(ev.target).data('song');
    $.ajax({url: '/db/media_link/', data: { path: song.path }, dataType: 'json', success: function(data){
      if(data && data.hasOwnProperty('url'))
        $('audio').attr('src', data.url)
    }});
  });
  $('#mybtn').on('click', function(){
    $.ajax({url: '/db/search/', dataType: 'json', success: refreshList});
  })
})
