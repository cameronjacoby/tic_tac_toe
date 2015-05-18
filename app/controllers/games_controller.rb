class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show]

  def create
    if Game.one_player.any?
      @game = Game.one_player.first
    else
      @game = Game.new(board_size: Game::DEFAULT_BOARD_SIZE)
      @game.create_board
    end
    unless @game.players.include?(current_user)
      @game.players << current_user
    end
    if @game.save!
      redirect_to game_path(@game)
    else
      redirect_to root_path
    end
  end

  def show
  end

  def play
    @game = Game.find(params[:id])
    board_position = params[:board_position].to_i
    player_index = params[:player_index].to_i
    player_avatar = params[:player_avatar]
    
    player = @game.players.by_plays[player_index]
    player.set_avatar!(player_avatar, @game)
    
    @game.moves[board_position] = player_index
    @game.save!

    # only check for winner if there are enough moves for there to be a winner
    if @game.moves.compact.count >= @game.board_size * 2 - 1
      winning_index = @game.get_winner
      if winning_index
        @game.update_attributes(winner: @game.players.by_plays[winning_index])
      end
    end

    WebsocketRails[:tic_tac_toe].trigger(:play, { game_id: @game.id, winner: @game.winner, last_player: player_index, last_player_avatar: player_avatar, board_pos: board_position })
    render nothing: true
  end

  private

    def set_game
      @game = Game.find(params[:id])
    end

end