$(function() {

  if (window.location.hash === '#_=_') {
    window.location.hash = '';
    history.pushState('', document.title, window.location.pathname);
  }

  setTimeout(function() {
    $('.alert').fadeOut('slow');
  }, 3000);

  // helper functions
  var fillBoardPos = function(element, avatar) {
    element.children('.avatar').attr('src', "/assets/" + avatar);
    element.children('.avatar').removeClass('add_opacity');
    element.children('.avatar').fadeIn('fast');
    element.addClass('filled');
  };

  // set initial game state
  var gameId = parseInt($('#game_id').val());
  var player = parseInt($('#player_index').val());
  var winnerDeclared = $('#winner_declared').val();
  var playerTurn = parseInt($('#player_turn').val());
  var playerAvatar = $('#player_avatar').val();
  var makeMove = player === playerTurn;

  // choose avatar
  $('.avatar_choices img').on('mouseover', function() {
    $(this).addClass('rotate');
    $(this).on('mouseleave', function() {
      $(this).removeClass('rotate');
    });
  });

  $('.avatar_choices img').on('click', function() {
    playerAvatar = $(this).attr('src').replace("/assets/", "");
    $('.avatar_choices').fadeOut('fast');
  });

  $('.game_col').on('mouseover', function() {
    if (!$(this).hasClass('filled') && !winnerDeclared && playerAvatar && makeMove) {
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

  // player sends move to server
  $('.game_col').on('click', function() {
    if (!$(this).hasClass('filled') && !winnerDeclared) {
      if (playerAvatar) {
        if (makeMove) {
          fillBoardPos($(this), playerAvatar);
          makeMove = false;
          $.ajax({
            url: "/games/" + gameId + "/play",
            data: {
              board_position: $(this).attr('data-board-pos'),
              player_index: player,
              player_avatar: playerAvatar
            },
            method: "PUT"
          });
        } else {
          alert("It's not your turn! Wait for your opponent to make a move.");
        }
      } else {
        alert("Select your game avatar before you can play!");
      }
    }
  });

  // listen for game changes
  var dispatcher = new WebSocketRails('localhost:3000/websocket');
  var channel = dispatcher.subscribe('tic_tac_toe');
  
  channel.bind('play', function(data) {
    if (parseInt(data.game_id) === gameId) {
      var clickedElement = $('.game_col[data-board-pos=' + data.board_pos + ']');
      fillBoardPos(clickedElement, data.last_player_avatar);
      if (parseInt(data.last_player) === player) {
        makeMove = false;
      } else {
        makeMove = true;
      }
      if (data.winner) {
        winnerDeclared = true;
      }
    }
  });

});