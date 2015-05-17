$(function() {

  if (window.location.hash === '#_=_') {
    window.location.hash = '';
    history.pushState('', document.title, window.location.pathname);
  }

  var avatars = {
    0: "/assets/cupcake.jpg",
    1: "/assets/doge.jpg"
  };

  var player = parseInt($('#player_index').val());
  var playerTurn = false;

  // first player (index 0) gets to start
  if (player === 0) {
    playerTurn = true;
  }

  $('.game_col').on('mouseover', function() {
    if (playerTurn && !$(this).hasClass('filled')) {
      $(this).children('.avatar').attr('src', avatars[player]);
      $(this).children('.avatar').fadeIn('fast');
    }
  });

  $('.game_col').on('mouseleave', function() {
    if (!$(this).hasClass('filled')) {
      $(this).children('.avatar').hide();
      $(this).children('.avatar').attr('src', "");
    }
  });

  $('.game_col').on('click', function() {
    if (playerTurn && !$(this).hasClass('filled')) {
      $(this).children('.avatar').attr('src', avatars[player]);
      $(this).children('.avatar').removeClass('add_opacity');
      $(this).children('.avatar').fadeIn('fast');
      $(this).addClass('filled');
      playerTurn = false;
    }
  });

});