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
    @game.players << current_user
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
    player = @game.players[player_index]
    # player.plays.where(game: @game).first.update_attributes(avatar: player_avatar)
    @game.moves[board_position] = player_index
    @game.save!

    # only check for winner if there are enough moves for there to be a winner
    if @game.moves.compact.count >= @game.board_size * 2 - 1
      winner = @game.get_winner
      if winner
        @game.update_attributes(winner: winner)
      end
    end

    respond_to do |format|
      format.html { render nothing: true }
      format.json { render json: @game, include: :winner, status: :ok }
    end
  end

  private

    def set_game
      @game = Game.find(params[:id])
    end

end