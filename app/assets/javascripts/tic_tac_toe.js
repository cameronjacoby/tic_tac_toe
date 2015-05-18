$(function() {

  if (window.location.hash === '#_=_') {
    window.location.hash = '';
    history.pushState('', document.title, window.location.pathname);
  }

  var gameId = $('#game_id').val();
  var player = parseInt($('#player_index').val());
  var playerTurn = false;
  var playerAvatar;

  // first player (index 0) gets to start
  if (player === 0) {
    playerTurn = true;
    playerAvatar = "cupcake.jpg";
  }
  else if (player === 1) {
    playerAvatar = "doge.jpg";
  }

  $('.game_col').on('mouseover', function() {
    if (playerTurn && !$(this).hasClass('filled')) {
      $(this).children('.avatar').attr('src', "/assets/" + playerAvatar);
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
      $(this).children('.avatar').attr('src', "/assets/" + playerAvatar);
      $(this).children('.avatar').removeClass('add_opacity');
      $(this).children('.avatar').fadeIn('fast');
      $(this).addClass('filled');
      playerTurn = false;
      $.ajax({
        url: "/games/" + gameId + "/play",
        data: {
          board_position: $(this).attr('data-board-pos'),
          player_index: player,
          player_avatar: playerAvatar
        },
        method: "PUT",
        dataType: "json",
        success: function(data) {
          console.log(data);
        }
      });
    }
  });

  var dispatcher = new WebSocketRails('localhost:3000/websocket');
  console.log(dispatcher);
  var channel = dispatcher.subscribe('tic_tac_toe');
  console.log(channel);
  channel.bind('play', function(data) {
    console.log('channel event received: ' + data.last_player.id);
  });

});