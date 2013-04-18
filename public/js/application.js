$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});







function setupMyThang() {
  $(document).ready(function(){
    function getTweetStatus(jid) { 
      $.get('/status/'+jid, function(status){
        $('span').append('<br>'+status);

        if (status != "Done!") { 
          setTimeout(function(){ getTweetStatus(jid)}, 5000); 
        }


      });
    }


    $('.tweet-submit').on('submit', function(e){
      e.preventDefault();

      var form = $(this);

      var data = form.serialize();
      console.log(data);
      $.post('/tweet', data, function(response){
        getTweetStatus(response);
      });

    });
  });
};
